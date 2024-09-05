// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpensesDataModelAdapter extends TypeAdapter<ExpensesDataModel> {
  @override
  final int typeId = 0;

  @override
  ExpensesDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpensesDataModel(
      expenseCost: fields[3] as double,
      expenseType: fields[0] as expenses,
      expenseDescription: fields[1] as String,
      expenseDate: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpensesDataModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.expenseType)
      ..writeByte(1)
      ..write(obj.expenseDescription)
      ..writeByte(2)
      ..write(obj.expenseDate)
      ..writeByte(3)
      ..write(obj.expenseCost)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpensesDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class expensesAdapter extends TypeAdapter<expenses> {
  @override
  final int typeId = 1;

  @override
  expenses read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return expenses.food;
      case 1:
        return expenses.drinks;
      case 2:
        return expenses.rent;
      case 3:
        return expenses.subscription;
      case 4:
        return expenses.clothes;
      case 5:
        return expenses.transportation;
      default:
        return expenses.food;
    }
  }

  @override
  void write(BinaryWriter writer, expenses obj) {
    switch (obj) {
      case expenses.food:
        writer.writeByte(0);
        break;
      case expenses.drinks:
        writer.writeByte(1);
        break;
      case expenses.rent:
        writer.writeByte(2);
        break;
      case expenses.subscription:
        writer.writeByte(3);
        break;
      case expenses.clothes:
        writer.writeByte(4);
        break;
      case expenses.transportation:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is expensesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
