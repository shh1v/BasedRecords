const express = require('express');
const router = express.Router();
const sql = require('mssql');
const moment = require('moment');

router.get('/', function(req, res) {
    let query1 = "SELECT * FROM ordersummary";
    let query2 = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = ";
    let query3 = "SELECT firstName, lastName FROM customer WHERE customerId = ";

    (async function() {
        try {
            let pool = await sql.connect(dbConfig);
            let results = await pool.request().query(query1);

            let orders = [];

            for(let i = 0; i<results.recordset.length; i++) {
                // Order Summary Query
                let result = results.recordset[i];

                // Name Query
                let nameResults = await pool.request()
                    .query(query3 + result.customerId);
                let name = nameResults.recordset[0];
                result.firstName = name.firstName;
                result.lastName = name.lastName;


                result.products = [];
                let productResults = await pool.request().query(query2 + result.orderId);
                for(let j = 0; j<productResults.recordset.length; j++) {
                    let product = productResults.recordset[j];
                    result.products.push(product);
                }
                orders.push(result);
            }
            console.dir(orders);
            res.render('listorder', {
                orders: orders,
                title: "Electric Lettuce Order List",
            })
        }
        catch (err) {
            console.dir(err);
        }
    })();
});

module.exports = router;
