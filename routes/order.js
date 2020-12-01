const express = require('express');
const router = express.Router();
const sql = require('mssql');
const moment = require('moment');
const customer = require('../utils/customer');

router.get('/', function (req, res, next) {

    // Get the product list
    let productList = false;
    if (req.session.productList && req.session.productList.length > 0) {
        productList = req.session.productList;
    }

    if (!productList) {
        res.redirect('/checkout?invalid=Your shopping list is empty');
        return;
    }

    productList = productList.filter(function (el) {
        return el != null;
    });

    // Get time
    const time = new Date(Date.now());

    // Get query parameters
    let customerUsername = req.query.customerId;
    let customerPassword = req.query.customerPass;
    let address = req.query.address;
    let address2 = req.query.address2;
    let city = req.query.city;
    let state = req.query.state;
    let country = req.query.country;
    let postalCode = req.query.postalCode;
    let payment = req.query.payment;

    (async function f() {
        const customerId = await customer.validateUserPass(customerUsername, customerPassword);
        if (!await validateUserPass(customerId, req.session.authenticatedUserId)) {
            res.redirect('/checkout?invalid=Invalid User ID or Password!');
            return;
        }
        if (!await validateShippingInfo(address, address2, city, state, country, postalCode)){
            res.redirect('/checkout?invalid=Invalid shipping info!');
            return;
        }
        if (!await validatePaymentMethod(payment)){
            res.redirect('/checkout?invalid=Invalid Payment Method!');
            return;
        }

        // Concatenate addresses
        if (address2){
            address += '\n'+address2;
        }

        // Calculate total amount
        let totalAmount = 0;
        for (let i = 0; i < productList.length; i++) {
            if (productList[i] == null) continue;
            productList[i].price = parseFloat(productList[i].price);
            totalAmount += productList[i].price * productList[i].quantity;
            productList[i].totalAmount = totalAmount;
        }

        let pool = await sql.connect(dbConfig);

        // Create order summary
        const query = `INSERT INTO ordersummary (orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId)
                           VALUES (@date, @totalAmount, @address, @city, @state, @postalCode, @country, @customerId);
            SELECT SCOPE_IDENTITY();`;
        let result = await pool.request()
            .input('date', sql.DateTime, time)
            .input('totalAmount', sql.Int, totalAmount)
            .input('address', sql.VarChar, address)
            .input('city', sql.VarChar, city)
            .input('state', sql.VarChar, state)
            .input('postalCode', sql.VarChar, postalCode)
            .input('country', sql.VarChar, country)
            .input('customerId', sql.Int, customerId)
            .query(query);
        let orderSummaryId = result.recordset[0][''];

        // Create order products
        for (let i = 0; i < productList.length; i++) {
            if (productList[i] == null) continue;
            const query = `INSERT INTO orderproduct (orderId, productId, quantity, price)
                               VALUES (@orderId, @productId, @quantity, @price)`;
            let result = await pool.request()
                .input('orderId', sql.Int, orderSummaryId)
                .input('productId', sql.Int, productList[i].id)
                .input('quantity', sql.Int, productList[i].quantity)
                .input('price', sql.Int, productList[i].price * productList[i].quantity)
                .query(query);
        }

        req.session.productList = [];
        res.render('order', {
            productList: productList,
            orderId: orderSummaryId,
            userId: customerId,
        });
    })();
});

async function validateUserPass(customerId, userId) {
    return customerId === userId;
}

async function validateShippingInfo(address, address2, city, state, country, postalCode) {
    return true;
}

async function validatePaymentMethod(paymentMethod) {
    return true;
}

module.exports = router;
