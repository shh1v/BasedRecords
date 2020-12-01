const exphbs = require('express-handlebars');

const hbs = exphbs.create({
    helpers: {
        addOne: function (index) {
            return index + 1;
        },
        fixed: function (num, digits) {
            return num.toFixed(digits);
        },
        paymentMethodFormat: function (paymentMethod) {
            const date = paymentMethod.paymentExpiryDate;
            return `[${paymentMethod.paymentType}] ${paymentMethod.paymentNumber} (${date.getMonth()+1}/${date.getFullYear()})`;
        }
    }
});

module.exports = hbs;

