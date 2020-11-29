const express = require('express');
const router = express.Router();
const sql = require('mssql');
router.post('/', function (req, res, next) {
    const reviewRating = req.body.reviewRating;
    const comment = req.body.reviewComment;
    const customerId = req.body.customerId;
    const productId = req.body.productId;
    const name = req.body.reviewName;
    const email = req.body.reviewEmail;
    const query = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment, enteredName, enteredEmail) VALUES (@reviewRating, GETDATE(), @customerId, @productId, @comment, @name, @email)";
    const query2 = "SELECT * FROM review WHERE customerId=@id AND productId=@pid";
    (async function () {
        try {
            let pool = await sql.connect(dbConfig);

            let checkCustomer = await pool.request()
                .input('id', sql.Int, customerId)
                .input('pid', sql.Int, productId)
                .query(query2);
            if (checkCustomer.recordset.length === 0) {
                let processReview = await pool.request()
                    .input('reviewRating', sql.Int, reviewRating)
                    .input('customerId', sql.Int, customerId)
                    .input('productId', sql.Int, productId)
                    .input('comment', sql.VarChar, comment)
                    .input('name', sql.VarChar, name)
                    .input('email', sql.VarChar, email)
                    .query(query);

                res.render('review', {
                    title: 'Product Review',
                    success: true
                });
            } else {
                res.render('review', {
                    title: 'Product Review',
                    failure: true
                });
            }
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
