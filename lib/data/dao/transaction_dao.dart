import 'package:gastos_app/data/local/app_database.dart';
import 'package:gastos_app/domain/transaction/i_transaction_dao.dart';
import 'package:gastos_app/domain/transaction/transaction_model.dart';
import 'package:sqflite/sqflite.dart';


class TransactionDao implements ITransactionDao {
  final AppDatabase _appDatabase;

  TransactionDao(this._appDatabase);

  @override
  Future<int> insertTransaction(TransactionModel transaction) async {
    Database db = await _appDatabase.db;

    // Validar producto (si se especificó)
    if (transaction.productId != null) {
      final productExists = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [transaction.productId],
      );
      if (productExists.isEmpty) throw Exception('Producto no existe');
    }

    return await db.insert('transactions', transaction.toMap());
  }

  @override
  Future<List<TransactionModel>> getUserTransactions(String userId) async {
    Database db = await _appDatabase.db;

    final maps = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

}
