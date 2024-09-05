import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:personal_tracker/presentation/widgets/drawer_widget.dart';
import 'package:personal_tracker/presentation/widgets/listview_widget.dart';
import 'package:personal_tracker/provider/currency_provider.dart';
import 'package:personal_tracker/provider/expense_list_provider.dart';
import 'package:personal_tracker/provider/route_provider.dart';
import 'package:personal_tracker/provider/sign_in_notifier.dart';

/*
every number for the ui should be used as a final variable and in a seperate file
so when we modify the ui we modify from these numbers directly

*/

class ExpenseTrackerScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usedCurrency = ref.watch(currencyNotifierProvider);
    final totalExpenses = ref
        .watch(expenseListProvider)
        .fold(0.0, (sum, expense) => sum + expense.expenseCost);

    // Format the total expenses with commas
    final formattedTotalExpenses =
        NumberFormat('#,###').format(totalExpenses.floor());

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(19.0),
            height: 200,
            width: MediaQuery.sizeOf(context).width,
            child: Card(
              color: Theme.of(context).colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          usedCurrency.symbol,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                        ),
                        SizedBox(width: 30),
                        Text(
                          formattedTotalExpenses,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                    Text(
                      usedCurrency.abbreviation,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w100,
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'All Expenses',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: ListviewWidget(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(routeNotifierProvider.notifier).goTo(AppRoute.addExpense);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
