import 'dart:core';
import 'dart:io';

import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/domain/expense/expense_model.dart';
import 'package:gastos_app/domain/user/user_model.dart';



abstract class IExpenseRepository {
  Future<Result<List<ExpenseModel>>> getAllExpenses();

  Future<Result<bool>> saveExpense(ExpenseModel expense);

  // Future<Result<ExpenseModel>> getCurrentExpense();

  // Future<Result<List<ExpenseModel>>> getCustomerAllExpenses();

  // Future<Result<bool>> updateFirstLogged();

  // Future<Result<ExpenseModel>> updateProfile(ExpenseModel user);

  // Future<Result<String>> updateExpenseImage({
  //   required String userId,
  //   required File image,
  // });

  // Future<Result<String>> getExpenseImageUrl(String userId);

  // Future<Result<List<ExpenseModel>>> getProjectExpenses(String projectId, {bool forceLocal = false});

  // Future<Result<List<ExpenseModel>>> getCustomerExpenses(String customerId, {bool forceLocal = false});

  // Future<Result<bool>> logout();
}