import 'package:gastos_app/data/remote/remote_constants.dart';
import 'package:gastos_app/domain/expense/expense_model.dart';
import 'package:gastos_app/domain/expense/i_expense_converter.dart';



class ExpenseConverter implements IExpenseConverter{

  @override
  ExpenseModel fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json[RemoteConstants.id] ?? "",
      date: json[RemoteConstants.date] ?? "",
      product: json[RemoteConstants.product] ?? "",
      price: double.tryParse(json[RemoteConstants.price]) ?? 0.0,
      amount: int.tryParse(json[RemoteConstants.amount]) ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson(ExpenseModel model) {
    return {
      RemoteConstants.id: model.id,
      RemoteConstants.date: model.date.toString(),
      RemoteConstants.product: model.product,
      RemoteConstants.price: (model.price ?? 0.0).toString(),
      RemoteConstants.amount: (model.amount ?? 0).toString(),
    };
  }
}
