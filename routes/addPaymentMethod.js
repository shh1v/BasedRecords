const auth = require('../auth');
const express = require('express');
const router = express.Router();
const sql = require('mssql');

router.get('/', function (req, res, next) {
    if (!auth.checkAuthentication(req, res)) {
        return;
    }

    res.render('addPaymentMethod', {
        title: 'Add a New Payment Method',
    });
});

router.post('/', function (req, res, next) {
    if (!auth.checkAuthentication(req, res)) {
        return;
    }

    const customerId = req.session.authenticatedUserId;
    // const customerId = 2;

    // Reading the data from request
    const paymentType = req.body.paymentType;
    const paymentNumber = req.body.paymentNumber;
    const expiryDate = req.body.expiryDate;


    // Validating the data
    if (!validatePaymentType(paymentType)) {
        res.render('addPaymentMethod', {
            title: 'Add a New Payment Method',
            invalid: 'Please provide a valid payment type from the list'
        });
        return;
    }
    if (!validatePaymentNumber(paymentNumber)) {
        res.render('addPaymentMethod', {
            title: 'Add a New Payment Method',
            invalid: 'Please provide a valid payment/card number'
        });
        return;
    }
    if (!validateExpiryDate(expiryDate)) {
        res.render('addPaymentMethod', {
            title: 'Add a New Payment Method',
            invalid: 'Please provide a valid expiry date make sure your payment method is not expired yet'
        });
        return;
    }
    const parsedExpiryDate = new Date(Date.parse(expiryDate));

    // Creating the payment method
    (async function f() {
        try {
            let pool = await sql.connect(dbConfig);
            await pool.request()
                .input('paymentType', sql.VarChar, paymentType)
                .input('paymentNumber', sql.VarChar, paymentNumber)
                .input('paymentExpiryDate', sql.Date, parsedExpiryDate)
                .input('customerId', sql.Int, customerId)
                .query(`INSERT INTO paymentmethod(paymentType, paymentNumber, paymentExpiryDate, customerId)
                        VALUES (@paymentType, @paymentNumber, @paymentExpiryDate, @customerId)`);

            res.render('addPaymentMethod', {
                title: 'Add a New Payment Method',
                valid: 'Payment method added successfully you can use it to checkout now'
            });
        } catch (err) {
            res.render('message', {
                type: 'danger',
                message: err,
            });
        }
    })();
});

function validatePaymentType(paymentType) {
    const paymentTypes = ['Credit Card', 'Debit Card', 'PayPal', 'Bitcoin', 'Cash'];
    return paymentType && paymentTypes.indexOf(paymentType) >= 0;
}

function validatePaymentNumber(paymentNumber) {
    const rx = /^(\d|-)+$/;
    return rx.test(paymentNumber);
}

function validateExpiryDate(expiryDate) {
    const rx = /^\d\d\d\d-\d\d$/;
    return rx.test(expiryDate);
}

module.exports = router;
