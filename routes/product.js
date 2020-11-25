const express = require('express');
const router = express.Router();
const sql = require('mssql');

router.get('/', function (req, res, next) {
    // Get product id
    let productId = req.query.id;

    const query = "SELECT * FROM product WHERE productId = @id";
    (async function() {
        try {
            let pool = await sql.connect(dbConfig);

            let result = await pool.request()
            .input('id', sql.Int, productId)
            .query(query);

            res.render('product', {
                title: 'Product Details',
                product: result.recordset[0]
            });
        } catch (e) {
            console.dir(e);
        }

    })();
});

module.exports = router;
