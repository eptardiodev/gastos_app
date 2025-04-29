import 'dart:convert';

import 'package:gastos_app/data/converter/expense_converter.dart';
import 'package:gastos_app/data/local/app_database.dart';
import 'package:gastos_app/data/local/db_constants.dart';
import 'package:gastos_app/domain/expense/expense_model.dart';
import 'package:gastos_app/domain/expense/i_expense_dao.dart';
import 'package:gastos_app/utils/extensions.dart';
import 'package:sqflite/sqlite_api.dart';

class ExpenseDao implements IExpenseDao {
  final AppDatabase _appDatabase;
  final ExpenseConverter _expenseConverter;

  ExpenseDao(this._appDatabase, this._expenseConverter);

  @override
  Future<List<ExpenseModel>> getAllExpenses() async {
    final List<ExpenseModel> list = [];
      try {
        Database db = await _appDatabase.db;
        final data = await db.query(DBConstants.expensesTable);
        for (var map in data) {
          final value = map[DBConstants.dataKey].objToString();
          final ExpenseModel obj = _expenseConverter.fromJson(json.decode(value));
          list.add(obj);
        }
        return list;
      } catch (ex) {
        return [];
      }
  }

  @override
  Future<bool> saveExpense(ExpenseModel expense) async {
    try {
      Database db = await _appDatabase.db;
      final map = {
        DBConstants.idKey: expense.id,
        DBConstants.date: expense.date,
        DBConstants.dataKey: json.encode(_expenseConverter.toJson(expense)),
      };
      await db.insert(DBConstants.expensesTable, map,
          conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    } catch (ex) {
      return false;
    }
  }
}