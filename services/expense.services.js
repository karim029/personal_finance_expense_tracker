const { default: mongoose } = require('mongoose');
const expenseModel = require('../models/expense.model');

class ExpenseService {
    static async addExpense(userId, expenseData) {
        try {

            const newExpense = new expenseModel({
                userId,
                ...expenseData,
            });
            const savedExpense = await newExpense.save();
            return savedExpense;
        } catch (error) {
            throw error;
        }
    }

    static async getUserExpenses(userId) {
        try {
            const expenses = await expenseModel.find({ userId });
            return expenses;
        } catch (error) {
            throw error;
        }
    }

    static async removeExpense(expenseId) {
        try {
            const result = await expenseModel.findOneAndDelete(expenseId);
            if (!result) {
                throw new Error('expense not found');
            }
            console.log(result);
            return result;
        } catch (error) {
            throw new Error(`Error deleting expense: ${error.message}`);

        }
    }
}

module.exports = ExpenseService;