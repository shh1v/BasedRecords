const express = require('express');
const router = express.Router();
const auth = require('../auth');
const sql = require('mssql');

router.post('/', function (req, res) {
    // Have to preserve async context since we make an async call
    // to the database in the validateLogin function.
    (async () => {
        let authenticatedUser = await validateLogin(req);
        if (authenticatedUser) {
            res.redirect("/");
        } else {
            res.redirect("/login");
        }
    })();
});

async function validateLogin(req) {
    if (!req.body || !req.body.username || !req.body.password) {
        return false;
    }

    let username = req.body.username;
    let password = req.body.password;
    let query = "SELECT customerId FROM customer WHERE userid=@username AND password=@password"
    let authenticatedUser = await (async function () {
        try {
            let pool = await sql.connect(dbConfig);
            let result = await pool.request()
                .input(['username', 'password'], [sql.Varchar, sql.Varchar], [username, password])
                .query(query)
            // TODO: Check if userId and password match some customer account.
            // If so, set authenticatedUser to be the username.
            console.dir(result);
            if (result.recordset[0]) {
                return true;
            } else {
                return false;
            }

        } catch (err) {
            console.dir(err);
            return false;
        }
    })();
    return authenticatedUser;
}

module.exports = router;
