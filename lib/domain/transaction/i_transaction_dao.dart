import 'package:gastos_app/domain/transaction/transaction_model.dart';

abstract class ITransactionDao {

  Future<int> insertTransaction(TransactionModel transaction);

  Future<List<TransactionModel>> getUserTransactions(String userId);

}
