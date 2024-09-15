import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'expenses_data_model.g.dart';

/// Model class to represent an expense record.
@HiveType(typeId: 0)
class ExpensesDataModel extends HiveObject {
  @HiveField(0)
  final expenses expenseType;

  @HiveField(1)
  final String expenseDescription;

  @HiveField(2)
  final DateTime? expenseDate;

  @HiveField(3)
  final double expenseCost;

  @HiveField(4)
  final String id;

  @HiveField(5)
  String? userId;

  ExpensesDataModel({
    this.userId,
    required this.expenseCost,
    required this.expenseType,
    required this.expenseDescription,
    this.expenseDate,
  }) : id = const Uuid().v4();

  /// Creates a copy of the current [ExpensesDataModel] with optional updates.
  ExpensesDataModel copyWith({
    String? userId,
    expenses? expenseType,
    String? expenseDescription,
    DateTime? expenseDate,
    double? expenseCost,
  }) {
    return ExpensesDataModel(
      userId: userId ?? this.userId,
      expenseType: expenseType ?? this.expenseType,
      expenseDescription: expenseDescription ?? this.expenseDescription,
      expenseDate: expenseDate ?? this.expenseDate,
      expenseCost: expenseCost ?? this.expenseCost,
    );
  }

  factory ExpensesDataModel.fromJson(Map<String, dynamic> json) {
    // Convert the expenseType string to the expenses enum
    final expenseTypeString = json['expenseType'] as String;
    final expenseType = expenses.values.firstWhere(
      (e) => e.toString().split('.').last == expenseTypeString,
    );

    // Handle the conversion of expenseDate from string to DateTime
    final expenseDateString = json['expenseDate'] as String?;
    final expenseDate =
        expenseDateString != null ? DateTime.parse(expenseDateString) : null;

    return ExpensesDataModel(
      userId: json['userId'] as String?,
      expenseCost: (json['expenseCost'] as num).toDouble(),
      expenseType: expenseType,
      expenseDescription: json['expenseDescription'] as String,
      expenseDate: expenseDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'expenseType': expenseType.name,
      'expenseCost': expenseCost,
      'expenseDescription': expenseDescription,
      'expenseDate': expenseDate?.toIso8601String(),
      'expenseId': id,
    };
  }
}

@HiveType(typeId: 1)
// ignore: camel_case_types
enum expenses {
  @HiveField(0)
  food,

  @HiveField(1)
  drinks,

  @HiveField(2)
  rent,

  @HiveField(3)
  subscription,

  @HiveField(4)
  clothes,

  @HiveField(5)
  transportation,
}

/// Maps expense types to icons.
final Map<expenses, Icon> expenseIcons = <expenses, Icon>{
  expenses.food: const Icon(Icons.fastfood, color: Colors.white),
  expenses.drinks: const Icon(Icons.local_drink, color: Colors.white),
  expenses.rent: const Icon(Icons.home, color: Colors.white),
  expenses.subscription: const Icon(Icons.subscriptions, color: Colors.white),
  expenses.clothes: const Icon(Icons.shopping_bag, color: Colors.white),
  expenses.transportation:
      const Icon(Icons.directions_car, color: Colors.white),
};
