const express = require('express');
const router = express.Router();
const sql = require('mssql');
const auth = require('../auth');

router.get('/', function (req, res, next) {

    let username;
    if (auth.checkAuthentication(req, res)) {
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
                res.render('customer', {
                    title: 'Customer Page',
                    info: result.recordset[0]
                });
            } catch (err) {
                console.dir(err);
                res.render('message', {
                    type: 'danger',
                    message: err,
                });
            }
        })();
    }
});

router.post('/', function (req, res, next) {
    let data = req.body;
    let customerId = data.customerId;
    let firstName = data.firstName;
    let lastName = data.lastName;
    let email = data.email;
    let phonenum = data.phone;
    let address = data.address;
    let city = data.city;
    let state = data.state;
    let postalCode = data.postalCode;
    let country = data.country;
    let userid = data.username;
    let password = data.password;
    
    const query = "UPDATE customer SET firstName = @firstName, lastName = @lastName, email = @email, phonenum = @phonenum, address = @address, city = @city, state = @state, postalCode = @postalCode, country = @country, userid = @userid, password = @password WHERE customerId = @customerId";
    (async function () {
        try {
            let pool = await sql.connect(dbConfig);

            let result = await pool.request()
                .input('firstName', sql.VarChar, firstName)
                .input('lastName', sql.VarChar, lastName)
                .input('email', sql.VarChar, email)
                .input('phonenum', sql.VarChar, phonenum)
                .input('address', sql.VarChar, address)
                .input('city', sql.VarChar, city)
                .input('state', sql.VarChar, state)
                .input('postalCode', sql.VarChar, postalCode)
                .input('country', sql.VarChar, country)
                .input('userid', sql.VarChar, userid)
                .input('password', sql.VarChar, password)
                .input('customerId', sql.Int, customerId)
                .query(query);
            res.redirect('/customer')
        } catch (err) {
            console.dir(err);
            res.render('message', {
                type: 'danger',
                message: err,
            });
        }

    })();
});

module.exports = router;
