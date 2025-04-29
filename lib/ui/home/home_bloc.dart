import 'package:gastos_app/base/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/domain/expense/expense_model.dart';
import 'package:gastos_app/domain/expense/i_expense_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:gastos_app/base/bloc_base.dart';
import '../../base/loading_handler.dart';

class HomeBloC extends BaseBloC with LoadingHandler, ErrorHandler {

  final IExpenseRepository _iExpenseRepository;
  HomeBloC(this._iExpenseRepository);

  final BehaviorSubject<List<ExpenseModel>> _expenseListSubject = BehaviorSubject();

  Stream<List<ExpenseModel>> get expenseListStream => _expenseListSubject.stream;


  void init(){
    getAllExpenses();
  }

  void getAllExpenses() async {
    List<ExpenseModel> expenseList = [];
    final res = await _iExpenseRepository.getAllExpenses();
    if (res is ResultSuccess<List<ExpenseModel>>) {
      expenseList = res.value;
    }
    _expenseListSubject.sink.add(expenseList);
  }

  Future<void> saveExpense(ExpenseModel expense) async {
    final res = await _iExpenseRepository.saveExpense(expense);
    if (res is ResultSuccess<bool> && res.value) {
      List<ExpenseModel> expenseList = _expenseListSubject.value.toList();
      expenseList.add(expense);
      _expenseListSubject.sink.add(expenseList);
    }
  }

  @override
  void dispose() {
    _expenseListSubject.close();
  }
}

