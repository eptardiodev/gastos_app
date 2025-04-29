import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/data/repository/base_repository.dart';
import 'package:gastos_app/data/shared_preferences/shared_preferences_managment.dart';
import 'package:gastos_app/domain/expense/expense_model.dart';
import 'package:gastos_app/domain/expense/i_expense_dao.dart';
import 'package:gastos_app/domain/expense/i_expense_repository.dart';
import 'package:gastos_app/utils/logger.dart';


class ExpenseRepository extends BaseRepository implements IExpenseRepository {
  final Logger _logger;
  final IExpenseDao _expenseDao;
  final SharedPreferencesManager sharedP;

  ExpenseRepository(
    this._logger,
    this._expenseDao,
    this.sharedP,
  );

  @override
  Future<Result<List<ExpenseModel>>> getAllExpenses() async {
    try {
      final res = await _expenseDao.getAllExpenses();
      return Result.success(value: res);
    } catch (ex) {
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<bool>> saveExpense(ExpenseModel expense) async {
    try {
      final value = await _expenseDao.saveExpense(expense);
      return Result.success(value: value);
    } catch (ex) {
      _logger.log(ex);
      return Result.error(error: ex);
    }
  }
}
