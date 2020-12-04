const express = require('express');
const router = express.Router();
const sql = require('mssql');
const auth = require('../auth');

router.get('/', function (req, res, next) {
    res.render('register', {
        title: 'Registration Page',
    });
});

router.post('/', function (req, res, next) {
    let data = req.body;
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

    const query = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES(@firstName, @lastName, @email, @phonenum, @address, @city, @state, @postalCode, @country, @userid, @password)";

    (async function(){
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
                .query(query);
            res.redirect('/login');
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
