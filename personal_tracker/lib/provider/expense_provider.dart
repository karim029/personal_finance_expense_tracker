import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tracker/domain/entities/expenses_data_model.dart';

class ExpenseNotifier extends Notifier<ExpensesDataModel> {
  bool isLoading = false;

  @override
  ExpensesDataModel build() {
    return ExpensesDataModel(
      expenseCost: 0.0,
      expenseType: expenses.food,
      expenseDescription: '',
      expenseDate: null,
    );
  }

  void updateExpenseDescription(String description) {
    state = state.copyWith(expenseDescription: description);
  }

  void updateExpenseCost(double cost) {
    state = state.copyWith(expenseCost: cost);
  }

  void updateExpenseDate(DateTime date) {
    state = state.copyWith(expenseDate: date);
  }

  void updateExpenseType(expenses type) {
    state = state.copyWith(expenseType: type);
  }

  void setuserIdforExpense(String userId) {
    state = state.copyWith(userId: userId);
  }

  void resetExpense() {
    state = ExpensesDataModel(
      expenseCost: 0.0,
      expenseType: expenses.food,
      expenseDescription: '',
      expenseDate: null,
    );
  }
}

final expenseNotifierProvider =
    NotifierProvider<ExpenseNotifier, ExpensesDataModel>(
  () => ExpenseNotifier(),
);
