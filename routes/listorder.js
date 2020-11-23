const express = require('express');
const router = express.Router();
const sql = require('mssql');
const moment = require('moment');

router.get('/', function(req, res) {
    let query1 = "SELECT * FROM ordersummary";
    let query2 = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = @orderId";
    let query3 = "SELECT firstName, lastName FROM customer WHERE customerId = @customerId";

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
                    .input('customerId', sql.Int, result.customerId)
                    .query(query3);
                let name = nameResults.recordset[0];
                result.firstName = name.firstName;
                result.lastName = name.lastName;


                result.products = [];
                let productResults = await pool.request()
                    .input('orderId', sql.Int, result.orderId)
                    .query(query2);
                for(let j = 0; j<productResults.recordset.length; j++) {
                    let product = productResults.recordset[j];
                    result.products.push(product);
                }
                orders.push(result);
            }
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
