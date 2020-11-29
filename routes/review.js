const express = require('express');
const router = express.Router();
const sql = require('mssql');
const auth = require('../auth');

router.get('/', function (req, res, next) {
    let productId = req.query.id;
    let username;
    if (auth.checkAuthentication(req, res)) {
        username = req.session.authenticatedUser;
        (async function () {
            try {
                const query = "SELECT productName, productId FROM product WHERE productId = @id";
                const query2 = "SELECT * FROM customer WHERE userid = @cust";
                let pool = await sql.connect(dbConfig);

                let result = await pool.request()
                    .input('id', sql.Int, productId)
                    .query(query);

                let customerResult = await pool.request()
                    .input('cust', sql.VarChar, username)
                    .query(query2);

                res.render('review', {
                    title: 'Product Review',
                    product: result.recordset[0],
                    customer: customerResult.recordset[0]
                });

            } catch (err) {
                console.dir(err);
                res.render('message', {
                    type: 'danger',
                    message: err,
                })
            }
        })();
    }
});

module.exports = router;
