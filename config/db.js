// import the lib mongoose
const mongoose = require('mongoose');

// create db connectivity with the local db on mongodb compass

const connection = mongoose.createConnection('mongodb://localhost:27017/ExpenseTracker').on('open', () => {
    console.log("MongoDb Connected");
}).on('error', () => {
    console.log("MongoDb connection error");
});

// export the module to use it

module.exports = connection;