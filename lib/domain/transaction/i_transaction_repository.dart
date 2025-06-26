import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/domain/transaction/transaction_model.dart';

abstract class ITransactionRepository {

  Future<Result<int>> insertTransaction(TransactionModel transaction);

  Future<Result<List<AllTransactionDataModel>>> getUserAllTransactionData(
      String userId);

  Future<Result<List<AllTransactionDataModel>>> getUserAllTransactionDataByDate(
      String userId, DateTime date);

  Future<Result<List<AllTransactionDataModel>>> getUserAllTransactionDataRangeDate(
      String userId, DateTime startDate, DateTime endDate);

  Future<Result<int>> updateTransaction(TransactionModel transaction);

  Future<Result<bool>> deleteTransaction(int transaction);

  Future<Result<bool>> deleteTransactions(List<int> transactionList);
}