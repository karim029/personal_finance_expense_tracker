// router -> controller -> service -> db


// create a registration api

const router = require('express').Router();
const UserController = require('../controllers/user.controller');

router.get('/test', (req, res) => {
    res.send('Test route working!');
});


// send the data to the server (API)
router.post('/registration', UserController.register);

router.post('/login', UserController.logIn);
module.exports = router;