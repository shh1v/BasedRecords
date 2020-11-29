const express = require('express');
const router = express.Router();
const sql = require('mssql');

router.get('/', function (req, res, next) {
    // Get product id
    let productId = req.query.id;

    const query = "SELECT * FROM product WHERE productId = @id";
    const query2 = "SELECT reviewRating, enteredName, reviewComment, CONVERT(varchar, reviewDate, 23) as date FROM review WHERE productId = @pid";
    (async function () {
        try {
            let pool = await sql.connect(dbConfig);

            let result = await pool.request()
                .input('id', sql.Int, productId)
                .query(query);

            let reviews = await pool.request()
                .input('pid', sql.Int, productId)
                .query(query2);

            res.render('product', {
                title: 'Product Details',
                product: result.recordset[0],
                reviews: reviews.recordset
            });
        } catch (err) {
            console.dir(err);
            res.render('message', {
                type: 'danger',
                message: err,
            })
        }

    })();
});

module.exports = router;
