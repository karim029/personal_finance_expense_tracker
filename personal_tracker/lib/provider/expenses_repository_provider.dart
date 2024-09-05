import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_tracker/data/repositories/expenses_repository.dart';
import 'package:http/http.dart' as http;

final ExpensesRepositoryProvider = Provider<ExpensesRepository>((ref) {
  return ExpensesRepository(http.Client());
});
