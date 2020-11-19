const sql = require('mssql');

exports.validateUserPass = async function (user, pass) {
    const query = `SELECT customerId FROM customer WHERE userid='${user}' AND password='${pass}'`;
    let pool = await sql.connect(dbConfig);
    let result = await pool.request().query(query);
    if(result.recordset.length === 0){
        return -1;
    }
    return result.recordset[0].customerId;
};
