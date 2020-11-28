const express = require('express');
const router = express.Router();

// Rendering the main page
router.get('/', function (req, res) {
    let username;
    if(req.session.authenticatedUser){
        username = req.session.authenticatedUser;
    } else {
        username = '';
    }
    // TODO: Display user name that is logged in (or nothing if not logged in)
    res.render('index', {
        title: "Electric Lettuce",
        username: username
    });
});

module.exports = router;
