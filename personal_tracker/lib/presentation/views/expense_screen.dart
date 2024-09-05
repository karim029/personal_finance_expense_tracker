import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tracker/domain/entities/expenses_data_model.dart';
import 'package:personal_tracker/provider/currency_provider.dart';
import 'package:personal_tracker/provider/expense_list_provider.dart';
import 'package:personal_tracker/provider/expense_provider.dart';
import 'package:personal_tracker/provider/registration_notifer.dart';
import 'package:personal_tracker/provider/route_provider.dart';
import 'package:personal_tracker/provider/sign_in_notifier.dart';

class ExpenseScreen extends ConsumerStatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends ConsumerState<ExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      ref.read(expenseNotifierProvider.notifier).updateExpenseDate(pickedDate);
    }
  }

  void _navigateToDashboard() {
    ref.read(expenseNotifierProvider.notifier).resetExpense();
    ref.read(routeNotifierProvider.notifier).goTo(AppRoute.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(signInNotifierProvider).userId ??
        ref.watch(registrationNotifierProvider).userId;
    final expense = ref.watch(expenseNotifierProvider);
    expense.userId = userId;
    final usedCurrency = ref.watch(currencyNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        leading: IconButton(
          onPressed: () {
            _navigateToDashboard();
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
                maxLength: 7,
                onChanged: (value) {
                  ref
                      .read(expenseNotifierProvider.notifier)
                      .updateExpenseCost(double.tryParse(value) ?? 0.0);
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: usedCurrency.symbol,
                  suffixText: usedCurrency.abbreviation,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                    // add validation for 0 input
                  } else if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expenses made for',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField2<expenses>(
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          barrierColor: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withAlpha(50),
                          menuItemStyleData: MenuItemStyleData(
                            height: 27,
                          ),
                          isExpanded: true,
                          value: expense.expenseType,
                          items: expenses.values.map((expenses expense) {
                            return DropdownMenuItem<expenses>(
                              value: expense,
                              child: Text(
                                expense.name.toUpperCase(),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            ref
                                .read(expenseNotifierProvider.notifier)
                                .updateExpenseType(value!);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: TextFormField(
                style: Theme.of(context).textTheme.bodyMedium!,
                textAlign: TextAlign.start,
                maxLength: 40,
                onChanged: (value) {
                  ref
                      .read(expenseNotifierProvider.notifier)
                      .updateExpenseDescription(value);
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Expense description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30),
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    child: Text(
                      'Pick a Date',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  expense.expenseDate != null
                      ? '${expense.expenseDate!.day}/${expense.expenseDate!.month}/${expense.expenseDate!.year}'
                      : 'No Date Chosen',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.inversePrimary,
                )),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ref.read(expenseListProvider.notifier).addExpense(expense);
                    ref.read(expenseNotifierProvider.notifier).resetExpense();
                    ref
                        .read(routeNotifierProvider.notifier)
                        .goTo(AppRoute.loading);
                    ;
                  }
                },
                child: Text(
                  'Save expense',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
