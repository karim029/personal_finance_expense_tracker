import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:personal_tracker/domain/entities/expenses_data_model.dart';

const url = 'http://localhost:3000/expenses/';

const addExpenseUrl = 'add-expense';
const userExpensesUrl = 'user-expenses?userId=';
const deleteExpenseurl = 'remove-expense/';

class ExpensesRepository {
  final http.Client _client;

  ExpensesRepository(this._client);

  // add expense method

  Future<void> addExpense(ExpensesDataModel newExpense) async {
    try {
      final response = await _client.post(
        Uri.parse(url + addExpenseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          newExpense.toJson(),
        ),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add expense: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to add expense');
    }
  }

  Future<List<ExpensesDataModel>> fetchUserExpenses(String userId) async {
    try {
      final response =
          await _client.get(Uri.parse('$url$userExpensesUrl$userId'));

      if (response.statusCode == 200) {
        // the whole body of the response
        final Map<String, dynamic> fullData = jsonDecode(response.body);
        // the part that belongs to the expenses
        final List<dynamic> expensesjson = fullData['expenses'];
        return expensesjson.map((json) {
          return ExpensesDataModel.fromJson(json);
        }).toList();
      } else {
        throw Exception('Failed to fetch expenses: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to fetch expenses');
    }
  }

  removeExpense(String expenseId, String signedUserId) async {
    try {
      final response = await _client.delete(
        Uri.parse(url + deleteExpenseurl + expenseId),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to remove expense: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to remove expense');
    }
  }
}
