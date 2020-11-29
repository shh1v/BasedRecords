const express = require('express');
const router = express.Router();
const sql = require('mssql');
router.post('/', function (req, res, next) {
    const reviewRating = req.body.reviewRating;
    const comment = req.body.reviewComment;
    const customerId = req.body.customerId;
    const productId = req.body.productId;
    const query = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (@reviewRating, GETDATE(), @customerId, @productId, @comment)";

    (async function () {
        let pool = await sql.connect(dbConfig);

        let processReview = await pool.request()
            .input('reviewRating', sql.Int, reviewRating)
            .input('customerId', sql.Int, customerId)
            .input('productId', sql.Int, productId)
            .input('comment', sql.VarChar, comment)
            .query(query);

        res.render('review', {
            title: 'Product Review',
            success: true
        });
    })();
});
module.exports = router;
