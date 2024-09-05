const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const expenseSchema = new Schema({
    userId: {
        type: String,
        required: true,
    },
    expenseType: {
        type: String,
        required: true,
    },
    expenseDescription: {
        type: String,
        required: true,
    },
    expenseDate: {
        require: false,
        type: Date,
    },
    expenseCost: {
        type: Number,
        required: true,
    },
    expenseId: {
        type: String,
        required: true,
        unique: true,
    },
});

const expenseModel = db.model('expense', expenseSchema);

module.exports = expenseModel;