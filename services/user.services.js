// import user model
const userModel = require('../models/user.model');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');

class UserService {
    static async registerUser(name, email, password, userId) {
        try {
            console.log("Registering user with email:", email); // Debugging log
            // make sure email is not existant
            const user = await userModel.findOne({ email: email });
            if (user) {
                return { success: false, message: 'User Already Exists' };
            }
            const createUser = new userModel({ name, email, password, userId });
            const savedUser = await createUser.save();

            // Generate email verification token with expiration
            const token = jwt.sign({ email }, process.env.JWT_SECRET, { expiresIn: '1h' });

            // Send verification email
            await this.sendVerificationEmail(email, token);

            // save the token to the user 
            savedUser.verificationToken = token;
            await savedUser.save();

            return { success: true, user: savedUser }; // Return success status and user

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
            subject: 'Verify Your Email Address',
            html: `
        <html>
        <head>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f4;
                    margin: 0;
                    padding: 0;
                }
                .container {
                    max-width: 600px;
                    margin: 20px auto;
                    background-color: #ffffff;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                }
                h1 {
                    color: #333333;
                    text-align: center;
                }
                p {
                    color: #555555;
                    font-size: 16px;
                    line-height: 1.5;
                }
                .button {
                    display: inline-block;
                    padding: 10px 20px;
                    font-size: 16px;
                    color: #ffffff;
                    background-color: #007bff;
                    text-decoration: none;
                    border-radius: 4px;
                    text-align: center;
                    margin: 20px 0;
                }
                .footer {
                    text-align: center;
                    font-size: 14px;
                    color: #999999;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>Email Verification</h1>
                <p>Hi there,</p>
                <p>Thank you for registering with us. To complete your registration, please verify your email address by clicking the button below:</p>
                <a href="http://localhost:3000/users/verify-email?token=${token}" class="button">Verify Your Email</a>
                <p>If you didn't create an account, no further action is required.</p>
                <p class="footer">Best regards,<br>RKY Co</p>
            </div>
        </body>
        </html>
    `
        };

        await transporter.sendMail(mailOptions);
    }

    static async verifyEmailToken(token) {
        try {
            // verify the token
            const decodedToken = jwt.verify(token, process.env.JWT_SECRET);
            const user = await userModel.findOne({ email: decodedToken.email });
            if (!user) {
                return { success: false, message: 'User not found' };
            }
            if (user.isVerified) {
                return { success: false, message: 'User already verified' };
            }

            // mark the user as verified
            user.isVerified = true;
            // delete token after verification
            user.verificationToken = null;
            await user.save();

            return { success: true, message: 'User verified successfully' };
        } catch (error) {
            if (error.name == 'TokenExpiredError') {
                return { success: false, message: 'Verification token has expired.' };
            }
            return { success: false, message: 'Invalid token.' };


        }
    }

    static async isUserVerified(userId) {
        try {
            const user = await userModel.findOne({ userId });
            if (user.isVerified) {
                return true;
            }
            else {
                return false;
            }
        } catch (error) {
            throw error;
        }
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