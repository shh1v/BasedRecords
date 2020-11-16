const express = require('express');
const router = express.Router();
const sql = require('mssql');
const moment = require('moment');

router.get('/', function(req, res) {
    res.setHeader('Content-Type', 'text/html');
    res.write('<title>Electric Lettuce Order List</title>');
    let query1 = "SELECT * FROM ordersummary";
    let query2 = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = ";
    let query3 = "SELECT firstName, lastName FROM customer WHERE customerId = ";
    let formatter = new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: '2'
    });

    (async function() {
        try {
            let pool = await sql.connect(dbConfig);

            let results = await pool.request()
                .query(query1);

            res.write("<table>" +
                "<tr>" +
                    "<th>Order Id</th>" +
                    "<th>Order Date</th>" +
                    "<th>Customer Id</th>" +
                    "<th>Customer Name</th>" +
                    "<th>Total Amount</th>" +
                "</tr>");
            for(let i = 0; i<results.recordset.length; i++) {
                let result = results.recordset[i];
                let nameResults = await pool.request()
                    .query(query3 + result.customerId);
                let name = nameResults.recordset[0];
                res.write("<tr>" +
                    "<td>" + result.orderId + "</td>" +
                    "<td>" + result.orderDate + "</td>" +
                    "<td>" + result.customerId + "</td>" +
                    "<td>" + name.firstName + " " + name.lastName +"</td>" +
                    "<td>" + formatter.format(result.totalAmount) + "</td>" +
                    "</tr>");
                res.write("<tr>" +
                    "<th></th>" +
                    "<th></th>" +
                    "<th>Product Id</th>" +
                    "<th>Quantity</th>" +
                    "<th>Price</th>" +
                    "</tr>");
                let productResults = await pool.request()
                .query(query2 + result.orderId);
                for(let j = 0; j<productResults.recordset.length; j++) {
                    let product = productResults.recordset[j];
                    res.write("<tr>" +
                    "<td></td>" +
                    "<td></td>" +
                    "<td>" + product.productId + "</td>" +
                    "<td>" + product.quantity + "</td>" +
                    "<td>" + formatter.format(product.price) + "</td>" +
                    "</tr>");
                }

            }
            res.write("</table>");
        }
        catch (err) {
            console.dir(err);
            res.write(err);
        }
        res.end();
    })();

    /** Create connection, and validate that it connected successfully **/

    /**
    Useful code for formatting currency:
        let num = 2.87879778;
        num = num.toFixed(2);
    **/

    /** Write query to retrieve all order headers **/

    /** For each order in the results
            Print out the order header information
            Write a query to retrieve the products in the order

            For each product in the order
                Write out product information 
    **/
});

module.exports = router;
