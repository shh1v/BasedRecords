const express = require('express');
const router = express.Router();
const sql = require('mssql');

router.get('/', function (req, res, next) {
    // Get product id
    let productId = req.query.id;


    const query = "SELECT * FROM product WHERE productId = id";
    // noinspection BadExpressionStatementJS
    (async function() {
        try {
            let pool = await sql.connect(dbConfig);

            let result = await pool.request()
            .input('productId', sql.Int, productId)
            .query(query);

            res.render('product', {
                title: 'Product Details',
                product: result.recordset
            });
        } catch (e) {
            console.dir(e);
        }

    });
    // Get product name to search for
    // TODO: Retrieve and display info for the product

    // TODO: If there is a productImageURL, display using IMG tag

    // TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.

    // TODO: Add links to Add to Cart and Continue Shopping
})();

module.exports = router;
