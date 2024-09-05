import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:personal_tracker/domain/entities/currency_model.dart';

class CurrencyNotifier extends Notifier<CurrencyModel> {
  @override
  CurrencyModel build() {
    final box = Hive.box<String>('currencyBox');
    final currencyKey = box.get('selectedCurrencyKey', defaultValue: 'USD');
    return currencyMap[currencyKey]!;
  }

  void changeCurrency(CurrencyModel newCurrency) {
    final box = Hive.box<String>('currencyBox');
    box.put('selectedCurrencyKey', newCurrency.abbreviation);

    state = newCurrency;
  }
}

//default currency value
final currencyNotifierProvider =
    NotifierProvider<CurrencyNotifier, CurrencyModel>(() {
  return CurrencyNotifier();
});
