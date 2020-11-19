const exphbs = require('express-handlebars');

const hbs = exphbs.create({
    helpers: {
        addOne: function (index) {
            return index + 1;
        },
        fixed: function (num, digits) {
            return num.toFixed(digits);
        }
    }
});

module.exports = hbs;

