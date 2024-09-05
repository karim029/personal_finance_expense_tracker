const ExpenseService = require('../services/expense.services');

exports.addExpense = async (req, res, next) => {
    console.log("Request received at /expenses/add-expense"); // Debugging log

    try {
        const { userId, ...expenseData } = req.body;
        const addedExpense = await ExpenseService.addExpense(userId, expenseData);
        res.status(201).json({ success: "Expense added", expense: addedExpense });
    } catch (error) {
        next(error);
    }
};

exports.getExpenses = async (req, res, next) => {
    try {
        const { userId } = req.query;
        const expenses = await ExpenseService.getUserExpenses(userId);
        res.status(200).json({ expenses });
    } catch (error) {
        next(error);
    }
};

exports.deleteExpense = async (req, res, next) => {
    try {
        const { id } = req.params;
        await ExpenseService.removeExpense(id);
        res.status(200).json({ success: 'Expense removed successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });

    }
}