import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/data/repository/base_repository.dart';
import 'package:gastos_app/domain/transaction/i_transaction_dao.dart';
import 'package:gastos_app/domain/transaction/i_transaction_repository.dart';
import 'package:gastos_app/domain/transaction/transaction_model.dart';
import 'package:gastos_app/utils/logger.dart';

class TransactionRepository extends BaseRepository implements ITransactionRepository {
  final Logger _logger;
  final ITransactionDao _transactionDao;

  TransactionRepository(
      this._logger,
      this._transactionDao,
      );

  @override
  Future<Result<int>> insertTransaction(TransactionModel transaction) async {
    try {
      final res = await _transactionDao.insertTransaction(transaction);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en insertTransaction: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<List<AllTransactionDataModel>>> getUserAllTransactionData(String userId) async {
    try {
      final res = await _transactionDao.getUserAllTransactionData(userId);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en getUserTransactions: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<List<AllTransactionDataModel>>> getUserAllTransactionDataByDate(String userId, DateTime date) async {
    try {
      final res = await _transactionDao.getUserAllTransactionDataByDate(userId, date);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en getUserAllTransactionDataByDate: $ex');
      return Result.error(error: ex);
    }
  }
}