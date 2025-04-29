
import 'package:gastos_app/domain/expense/expense_model.dart';

abstract class IExpenseConverter {

  ExpenseModel fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(ExpenseModel model);

}