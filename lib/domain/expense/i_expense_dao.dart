import 'package:gastos_app/domain/expense/expense_model.dart';


abstract class IExpenseDao {
  // Future<bool> saveExpenses(List<ExpenseModel> list);

  Future<bool> saveExpense(ExpenseModel expense);

  Future<List<ExpenseModel>> getAllExpenses();

}