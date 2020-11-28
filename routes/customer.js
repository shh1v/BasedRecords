const express = require('express');
const router = express.Router();
const sql = require('mssql');
const auth = require('../auth');

router.get('/', function(req, res, next) {

    let username;
    if(auth.checkAuthentication(req, res)) {
        username = req.session.authenticatedUser;

        (async function () {
            try {
                // Select all fields where userid is the authenticated user
                const query = "SELECT * FROM customer WHERE userid = @username";
                let pool = await sql.connect(dbConfig);
                let result = await pool.request()
                    .input('username', sql.VarChar, username)
                    .query(query);

                // Render customer.handlebars, set title, store query result
                res.render('customers', {
                    title: 'Customer Page',
                    info: result.recordset
                });
                // TODO: Print customer info
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
