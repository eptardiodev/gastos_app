import 'package:gastos_app/data/remote/remote_constants.dart';
import 'package:gastos_app/domain/transaction/i_transaction_converter.dart';
import 'package:gastos_app/domain/transaction/transaction_model.dart';

class TransactionConverter implements ITransactionConverter{

  @override
  TransactionModel fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      userId: "12",
      amount: 2,
      date: DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toJson(TransactionModel model) {
    return {
      RemoteConstants.user_id: model.userId,
      
    };
  }
}
