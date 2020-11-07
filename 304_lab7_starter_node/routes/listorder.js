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

            let sqlQuery = "SELECT * FROM product";
            let results = await pool.request()
                .query(sqlQuery);
            console.dir(results)

            res.write("<table>" +
                "<tr>" +
                    "<th>Product Name</th>" +
                    "<th>Category ID</th>" +
                    "<th>Product Description</th>" +
                    "<th>Price</th>" +
                "</tr>");
            for(let i = 0; i<results.length; i++) {
                let result = results[i];
                res.write("<tr>" +
                    "<td>" + result.productName + "</td>" +
                    "<td>" + result.categoryId + "</td>" +
                    "<td>" + result.productDesc + "</td>" +
                    "<td>" + result.productPrice + "</td>" +
                    "</tr>");
            }
            res.write("</table>");
        }
        catch (err) {
            console.dir(err);
            res.write(err);
        }
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
