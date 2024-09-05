import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tracker/domain/entities/currency_model.dart';
import 'package:personal_tracker/provider/currency_provider.dart';

class CurrencyDropdown extends ConsumerWidget {
  const CurrencyDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCurrency = ref.watch(currencyNotifierProvider);
    print(selectedCurrency);
    return DropdownButtonFormField2<CurrencyModel>(
      menuItemStyleData: MenuItemStyleData(
          overlayColor: WidgetStatePropertyAll(
        Colors.white,
      )),
      items: currencyMap.values.map(
        (CurrencyModel currency) {
          return DropdownMenuItem<CurrencyModel>(
            child: Text(
              currency.abbreviation,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            value: currency,
          );
        },
      ).toList(),
      onChanged: (CurrencyModel? newCurrency) {
        if (newCurrency != null) {
          ref
              .read(currencyNotifierProvider.notifier)
              .changeCurrency(newCurrency);
        }
      },
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      barrierColor:
          Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(50),
      value: selectedCurrency,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
    );
  }
}
