const express = require('express');
const router = express.Router();
const sql = require('mssql');
const auth = require('../auth');

router.get('/', function(req, res, next) {

    // Use auth.js to check if authenticated. If true, set username = authenticatedUser from session
    let username;
    if(auth.checkAuthentication)
        username = req.session.authenticatedUser;
    // TODO: Print Customer information
    (async function() {
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
        } catch(err) {
            console.dir(err);
            res.write(err + "")
            res.end();
        }
    })();
});

module.exports = router;
