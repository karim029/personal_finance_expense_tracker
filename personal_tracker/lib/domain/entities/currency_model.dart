import 'package:hive_flutter/hive_flutter.dart';

part 'currency_model.g.dart';

@HiveType(typeId: 2)
class CurrencyModel {
  @HiveField(0)
  final String abbreviation;
  @HiveField(1)
  final String symbol;

  CurrencyModel({required this.abbreviation, required this.symbol});
}

Map<String, CurrencyModel> currencyMap = {
  'USD': CurrencyModel(abbreviation: 'USD', symbol: '\$'),
  'EUR': CurrencyModel(abbreviation: 'EUR', symbol: '€'),
  'JPY': CurrencyModel(abbreviation: 'JPY', symbol: '¥'),
  'EGY': CurrencyModel(abbreviation: 'EGY', symbol: 'E€'),
};
