const UserService = require('../services/user.services');

// create a function to handle requests and response from/to frontend

exports.register = async (req, res, next) => {
    console.log("Request received at /registration"); // Debugging log

    try {
        // save the request body to email and password
        const { name, email, password, userId } = req.body;

        // send them to the userservice function 
        const successRes = await UserService.registerUser(name, email, password, userId);

        // send an acknowledge ar Nak
        res.status(201).json({ success: "User Registered Successfully" });

    } catch (error) {

        // duplicate email error
        if (error.message === 'Email is already registered') {
            return res.status(400).json({ error: error.message });
        }

        next(error);
    }
};

exports.verifyEmail = async (req, res) => {
    try {
        const { token } = req.query;
        if (!token) {
            return res.status(400).send('Verification token is required');
        }
        const result = await UserService.verifyEmail(token);

        if (result.success) {
            return res.status(200).send(result.message);
        } else {
            return res.status(400).send(result.message);
        }
    } catch (error) {
        next(error);
    }
}

exports.logIn = async (req, res, next) => {
    console.log("Request received at /login");

    try {
        const { email, password } = req.body;
        const existingUser = await UserService.findUserByEmail(email);
        if (!existingUser) {
            return res.status(404).json({ error: 'User not found' });
        }

        const isPassValid = await UserService.verifyPassword(password, existingUser.password);
        if (existingUser && !isPassValid) {
            return res.status(401).json({ error: 'Invalid password or email' });
        }
        if (!existingUser.isVerified) {
            return res.status(403).json({ error: 'Please veify your email first' });
        }

        // if success return user data
        res.status(200).json({
            success: 'User logged in successfully',
            user: {
                userId: existingUser.userId,
                name: existingUser.name,
                email: existingUser.email,
            }
        })
    } catch (error) {

    }
};