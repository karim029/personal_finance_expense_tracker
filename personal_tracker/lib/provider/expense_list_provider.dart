import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_tracker/data/repositories/expenses_repository.dart';
import 'package:personal_tracker/domain/entities/expenses_data_model.dart';
import 'package:personal_tracker/provider/expenses_repository_provider.dart';
import 'package:personal_tracker/provider/registration_notifer.dart';
import 'package:personal_tracker/provider/sign_in_notifier.dart';

class ExpenseListNotifier extends Notifier<List<ExpensesDataModel>> {
  late Box<ExpensesDataModel> _expenseBox;
  late ExpensesRepository _expensesRepository;

  @override
  List<ExpensesDataModel> build() {
    _expensesRepository = ref.watch(expensesRepositoryProvider);
    _expenseBox = Hive.box<ExpensesDataModel>('expenses');

    fetchUserExpenses();
    return _expenseBox.values.toList();
  }

  Future<void> addExpense(ExpensesDataModel expense) async {
    _expenseBox.add(expense);
    state = _expenseBox.values.toList();

    // server
    try {
      await _expensesRepository.addExpense(expense);
    } catch (e) {
      print('Failed to add expense to the backend: $e');
    }
  }

  void removeExpense(int index) async {
    final expenseToRemove = _expenseBox.getAt(index);
    if (expenseToRemove == null) return;

    // locally
    _expenseBox.deleteAt(index);
    state = _expenseBox.values.toList();

    // server
    try {
      final signedUserId = ref.watch(signInNotifierProvider).userId ??
          ref.watch(registrationNotifierProvider).userId;
      if (signedUserId == null) return;

      await _expensesRepository.removeExpense(expenseToRemove.id, signedUserId);
    } catch (e) {
      print('failed to remove expense from the backend: $e');
    }
  }

  Future<void> fetchUserExpenses() async {
    final signedUserId = ref.watch(signInNotifierProvider).userId ??
        ref.watch(registrationNotifierProvider).userId;
    if (signedUserId == null) return;
    try {
      // fetch user expenses from the server
      final fetchedExpenses =
          await _expensesRepository.fetchUserExpenses(signedUserId);

      // clear local box and add the fetched expenses
      await _expenseBox.clear();
      await _expenseBox.addAll(fetchedExpenses);

      state = _expenseBox.values.toList();
    } catch (e) {
      print('Failed to fetch expenses: $e');
    }
  }

  void resetExpenses() {
    _expenseBox.clear();
    state = [];
  }
}

final expenseListProvider =
    NotifierProvider<ExpenseListNotifier, List<ExpensesDataModel>>(
  () => ExpenseListNotifier(),
);
