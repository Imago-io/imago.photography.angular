require("coffee-script/register");

exports.config = {

    specs: [
        './e2e/**/*.spec.coffee'
    ],

    baseUrl: 'http://localhost:3002'
};