const express = require('express');
const router = express.Router();
const sql = require('mssql');
const auth = require('../auth');

router.get('/', function(req, res, next) {
    if(!auth.checkAuthentication(req, res)) return;

    const customerId = req.session.authenticatedUserId;
    const invalid = req.query.invalid;

    (async function f() {
        try {
            let pool = await sql.connect(dbConfig);
            let results = await pool.request()
                .input('customerId', sql.Int, customerId)
                .query(`SELECT *
                        FROM paymentmethod
                        WHERE customerId = @customerId`);

            res.render('checkout', {
                title: 'Grocery CheckOut Line',
                paymentMethods: results.recordset,
                invalid: invalid,
            });
        } catch (err) {
            res.render('message', {
                type: 'danger',
                message: err,
            });
        }
    })();
});

module.exports = router;
