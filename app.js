// install express.js
// to import any pacakge we use require
const express = require('express');

// import parser to use and read json
const body_parser = require('body-parser');

// import the router
const userRouter = require('./routers/user.router');
const expenseRouter = require('./routers/expense.router');
const app = express();

app.use(body_parser.json());

// Use the routers
app.use('/users', userRouter);        // Routes related to users
app.use('/expenses', expenseRouter);  // Routes related to expenses

//export the app to use it inside any other .js file
module.exports = app;