const router = require('express').Router();
const expenseController = require('../controllers/expense.controller');
// Define routes
router.post('/add-expense', expenseController.addExpense);
router.get('/user-expenses', expenseController.getExpenses);
router.delete('/remove-expense/:id', expenseController.deleteExpense);

module.exports = router;
