// router -> controller -> service -> db


// create a registration api

const router = require('express').Router();
const UserController = require('../controllers/user.controller');

router.get('/test', (req, res) => {
    res.send('Test route working!');
});


// send the data to the server (API)
router.post('/registration', UserController.register);

router.post('/check-verification', UserController.checkVerification);

router.post('/login', UserController.logIn);

router.get('/verify-email', UserController.verifyEmail);
module.exports = router;