const express = require('express');
const router = express.Router();
const sql = require('mssql');

router.get('/', function (req, res, next) {
    (async function f() {
        try {
            let pool = await sql.connect(dbConfig);

            let result = await pool.request()
                .query(`SELECT *
                        FROM warehouse`);

            res.render('warehouse/list', {
                warehouses: result.recordset,
            })
        } catch (e) {
            console.dir(e);
            res.render('message', {
                type: 'danger',
                message: e,
            })
        }
    })();
});

router.get('/:warehouseId', function (req, res, next) {
    (async function f() {
        try {
            const warehouseId = req.params.warehouseId;

            let pool = await sql.connect(dbConfig);

            let result = await pool.request()
                .input('warehouseId', sql.Int, warehouseId)
                .query(`SELECT product.productId, quantity, price, productName, productImageURL
                        FROM productinventory
                                 INNER JOIN product ON productinventory.productId = product.productId
                        WHERE warehouseId = @warehouseId`);
            res.render('warehouse/inventory', {
                products: result.recordset,
            })
        } catch (e) {
            console.dir(e);
            res.render('message', {
                type: 'danger',
                message: e,
            })
        }
    })();
});

module.exports = router;
