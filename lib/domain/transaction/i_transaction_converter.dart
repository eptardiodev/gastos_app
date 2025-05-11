import 'package:gastos_app/domain/transaction/transaction_model.dart';


abstract class ITransactionConverter {

  TransactionModel fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(TransactionModel model);

}