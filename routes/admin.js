const express = require('express');
const router = express.Router();
const auth = require('../auth');
const sql = require('mssql');

router.get('/', function(req, res, next) {
    //if(auth.checkAuthentication) {
        const query = "SELECT CONVERT(varchar, orderDate, 23) as dateOrdered, SUM(totalAmount) as totalAmountEarned FROM ordersummary GROUP BY CONVERT(varchar, orderDate, 23) ORDER BY CONVERT(varchar, orderDate, 23)";
        (async function() {
            try {
                let pool = await sql.connect(dbConfig);
                let result = await pool.request()
                    .query(query);
                res.render('admin', {
                    title: 'Admin Sales Report',
                    sales: result.recordset
                });
            } catch(err) {
                console.dir(err);
                res.write(err + "");
                res.end();
            }
        })();
    //}
});

module.exports = router;
