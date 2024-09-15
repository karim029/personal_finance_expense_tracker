const UserService = require('../services/user.services');

// create a function to handle requests and response from/to frontend

exports.register = async (req, res, next) => {
    console.log("Request received at /registration"); // Debugging log

    try {
        // save the request body to email and password
        const { name, email, password, userId } = req.body;

        // send them to the userservice function 
        const successRes = await UserService.registerUser(name, email, password, userId);
        if (!successRes.success) {
            res.status(403).json({ success: successRes.message });
        }
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

exports.resendVerification = async (req, res, next) => {
    const { userId } = req.body;
    try {

        const result = await UserService.resendVerificationEmail(userId);
        if (!result.success) {
            return res.status(400).json({ message: result.message });
        }
        return res.status(200).json({ message: result.message });

    } catch (error) {
        return res.status(500).json({ message: 'Server error' });

    }
}

exports.checkVerification = async (req, res, next) => {
    try {
        const { userId } = req.body;
        console.log("Checking verification status for userId:", userId); // Debugging log


        const verificationStatus = await UserService.isUserVerified(userId);
        if (verificationStatus) {
            console.log(verificationStatus);

            return res.status(200).json({ isVerified: true });
        } else {
            console.log(verificationStatus);

            return res.status(400).json({ isVerified: false });

        }
    } catch (error) {
        next(error);

    }
}

exports.verifyEmail = async (req, res, next) => {
    try {
        const { token } = req.query;
        if (!token) {
            return res.status(400).send('Verification token is required');
        }
        const result = await UserService.verifyEmailToken(token);

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
        console.log(isPassValid);
        if (!isPassValid) {
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

exports.requestResetCode = async (req, res, next) => {
    const { email } = req.body;
    try {
        const response = await UserService.generatePassResetCode(email);
        if (response.success) {
            return res.status(200).json({ message: response.message });

        }
        return res.status(400).json({ message: response.message });
    } catch (error) {
        next(error);

    }

    exports.verifyResetCode = async (req, res, next) => {
        const { email, resetCode } = req.body;
        try {
            const response = await UserService.verifyResetCode(email, resetCode);
            if (!response.success) {
                return res.status(400).json({ message: response.message });
            }
            res.status(200).json({ message: response.message });


        } catch (error) {
            next(error);
        }
    }
}