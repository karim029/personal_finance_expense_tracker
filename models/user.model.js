// user model db scheme

const mongoose = require('mongoose');
const db = require('../config/db');
const bcrypt = require('bcrypt');

// scheme property ( destructing assignment in JS)
// When you see const { } = mongoose;, it typically means you are extracting specific properties
//  or methods from the mongoose object and assigning them to variables.
const { Schema } = mongoose;

// can be written const Scheme = mongoose.Scheme

// create a user schema

const userSchema = new Schema({
    name: {
        type: String,
        lowercase: true,
        trim: true,
        required: true,
    },
    email: {
        type: String,
        lowercase: true,
        required: true,
        unique: true,
        trim: true,

    },
    password: {
        type: String,
        required: true,
    },

    userId: {
        type: String,
        required: true,
        unique: true,
    },
    isVerified: {
        type: Boolean,
        default: false,
    },
    verificationToken: { type: String },
});

userSchema.pre('save', async function () {
    try {
        var user = this;
        const salt = await (bcrypt.genSalt(10));
        const hashedPass = await bcrypt.hash(user.password, salt);

        user.password = hashedPass;
    } catch (error) {
        throw error;
    }
})

// create the user model
const userModel = db.model('user', userSchema);

// export this file to use the user model anywhere in our project
module.exports = userModel;
