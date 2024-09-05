// import everything in the app.js folder here
const app = require('./app');

// import db here
const db = require('./config/db');

// import the usermodel
const userModel = require('./models/user.model');

// creating server

// define a port
const port = 3000;


// listen and say if the server is listening to this port
app.listen(port, () => {
    console.log(`Server Listening on Port http://localhost:${port}`);
});