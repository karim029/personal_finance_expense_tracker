// import user model
const userModel = require('../models/user.model');
const bcrypt = require('bcrypt');

class UserService {
    static async registerUser(name, email, password, userId) {
        try {
            console.log("Registering user with email:", email); // Debugging log

            const createUser = new userModel({ name, email, password, userId });
            const savedUser = await createUser.save();
            return savedUser;   // saves the model (Collection) in the db

        } catch (error) {
            console.error("Error in UserService.registerUser:", error); // Debugging log

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