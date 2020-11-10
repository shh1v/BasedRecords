const express = require('express');
const router = express.Router();
const sql = require('mssql');
const moment = require('moment');

router.get('/', function(req, res) {
    res.setHeader('Content-Type', 'text/html');
    res.write('<title>Electric Lettuce Order List</title>');

    (async function() {
        try {
            let pool = await sql.connect(dbConfig);

            let sqlQuery = "SELECT * FROM ordersummary";
            let results = await pool.request()
                .query(sqlQuery);

            res.write("<table>" +
                "<tr>" +
                    "<th>Order Id</th>" +
                    "<th>Order Date</th>" +
                    "<th>Total Amount</th>" +
                    "<th>Address</th>" +
                    "<th>City</th>" +
                    "<th>State</th>" +
                    "<th>Postal Code</th>" +
                    "<th>Country</th>" +
                    "<th>Customer Id</th>" +
                "</tr>");
            for(let i = 0; i<results.recordset.length; i++) {
                let result = results.recordset[i];
                res.write("<tr>" +
                    "<td>" + result.orderId + "</td>" +
                    "<td>" + result.orderDate + "</td>" +
                    "<td>" + result.totalAmount + "</td>" +
                    "<td>" + result.shiptoAddress + "</td>" +
                    "<td>" + result.shiptoCity + "</td>" +
                    "<td>" + result.shiptoState + "</td>" +
                    "<td>" + result.shiptoPostalCode + "</td>" +
                    "<td>" + result.shiptoCountry + "</td>" +
                    "<td>" + result.customerId + "</td>" +
                    "</tr>");
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
