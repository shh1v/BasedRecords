const express = require('express');
const router = express.Router();
const sql = require('mssql');

router.get('/', function(req, res, next) {

    // Get the product name to search for
    let name = req.query.productName;

    let query;
    if (typeof(name) == 'undefined') {
        query = "SELECT * FROM product";
    }
    else{
        query = `SELECT * FROM product WHERE productName LIKE '%'+@name+'%'`;
    }


    (async function f() {
        let pool = await sql.connect(dbConfig);

        let result = await pool.request()
            .input('name', sql.VarChar, name)
            .query(query);

        res.render('product/list', {
            title: "Products",
            products: result.recordset
        });

    })();
});

module.exports = router;
