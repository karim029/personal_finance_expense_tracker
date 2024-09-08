// import user model
const userModel = require('../models/user.model');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');

class UserService {
    static async registerUser(name, email, password, userId) {
        try {
            console.log("Registering user with email:", email); // Debugging log

            const createUser = new userModel({ name, email, password, userId });
            const savedUser = await createUser.save();

            // Generate email verification token with expiration
            const token = jwt.sign({ email }, process.env.JWT_SECRET, { expiresIn: '1d' });

            // Send verification email
            await this.sendVerificationEmail(email, token);

            // save the token to the user 
            savedUser.verificationToken = token;
            await savedUser.save();

            return savedUser;   // saves the model (Collection) in the db

        } catch (error) {
            console.error("Error in UserService.registerUser:", error); // Debugging log

            throw error;
        }
    }

    static async sendVerificationEmail(email, token) {
        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS,
            }
        });

        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: email,
            subject: 'Verify your Email',
            html: `<h1>Email Verification</h1>
                   <p>Click the link to verify your email:</p>
                   <a href="http://localhost:3000/users/verify-email?token=${token}">Verify Email</a>`
        };

        await transporter.sendMail(mailOptions);
    }

    static async findUserByEmail(email) {
        try {
            console.log("Finding user with email: ", email);

            // check if email exists
            const foundUser = await userModel.findOne({ email });
            console.log(foundUser);
            return foundUser;

        } catch (error) {
            console.error("Error in UserService.findUserByEmail:", error);

            throw error;
        }
    }

    static async verifyPassword(inputPass, storedPass) {
        try {
            return await bcrypt.compare(inputPass, storedPass);
        } catch (error) {

            console.error("Error in UserService.verifyPassword:", error);

            throw error;
        }
    }
}

module.exports = UserService;