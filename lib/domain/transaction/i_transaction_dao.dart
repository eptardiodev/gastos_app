import 'package:gastos_app/domain/transaction/transaction_model.dart';

abstract class ITransactionDao {

  Future<int> insertTransaction(TransactionModel transaction);

  // Future<List<TransactionModel>> getUserTransactions(String userId);

  Future<List<AllTransactionDataModel>> getUserAllTransactionData(
      String userId);

  Future<List<AllTransactionDataModel>> getUserAllTransactionDataByDate(
      String userId, DateTime date);

  Future<List<AllTransactionDataModel>> getUserAllTransactionDataRangeDate(
      String userId, DateTime startDate, DateTime endDate);

}
