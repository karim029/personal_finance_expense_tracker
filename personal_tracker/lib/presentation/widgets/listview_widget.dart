import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:personal_tracker/domain/entities/expenses_data_model.dart';
import 'package:personal_tracker/provider/currency_provider.dart';
import 'package:personal_tracker/provider/expense_list_provider.dart';

class ListviewWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesList = ref.watch(expenseListProvider);
    final usedCurrency = ref.watch(currencyNotifierProvider);

    return expensesList.isEmpty
        ? Center(
            child: Text(
              'No current expenses',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          )
        : ListView.builder(
            itemCount: expensesList.length,
            itemBuilder: (context, index) {
              final expense = expensesList[index];

              final formattedDate = expense.expenseDate != null
                  ? DateFormat('dd/MM/yy').format(expense.expenseDate!)
                  : DateFormat('dd/MM/yy').format(DateTime.now());

              return Dismissible(
                key: ValueKey(expensesList[index]),
                onDismissed: (direction) {
                  ref.read(expenseListProvider.notifier).removeExpense(index);
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: expenseIcons[expense.expenseType],
                      ),
                    ),
                    title: Text(
                      expense.expenseType.name,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                    subtitle: Text(expense.expenseDescription),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${usedCurrency.symbol} ${expense.expenseCost.floor().toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              formattedDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
