import 'package:gastos_app/data/local/app_database.dart';
import 'package:gastos_app/domain/product/i_product_dao.dart';
import 'package:gastos_app/domain/product/product_model.dart';
import 'package:gastos_app/domain/transaction/i_transaction_dao.dart';
import 'package:gastos_app/domain/transaction/transaction_model.dart';
import 'package:sqflite/sqflite.dart';


class TransactionDao implements ITransactionDao {
  final AppDatabase _appDatabase;
  final IProductDao _iProductDao;

  TransactionDao(this._appDatabase, this._iProductDao);

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
  Future<List<AllTransactionDataModel>> getUserAllTransactionData(String userId) async {
    Database db = await _appDatabase.db;

    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT 
      t.id AS transaction_id,
      t.amount,
      t.quantity,
      t.price,
      t.place,
      t.date,
      t.notes,
      t.unit_id,
      p.id AS product_id,
      p.name AS product_name,
      p.description AS product_description,
      p.common_unit,
      sc.id AS subcategory_id,
      sc.name AS subcategory_name,
      c.id AS category_id,
      c.name AS category_name,
      c.icon_name AS category_icon,
      c.color_hex AS category_color,
      mu.name AS unit_name,
      mu.symbol AS unit_symbol
    FROM transactions t
    LEFT JOIN products p ON t.product_id = p.id
    LEFT JOIN subcategories sc ON p.subcategory_id = sc.id
    LEFT JOIN categories c ON sc.category_id = c.id
    LEFT JOIN measurement_units mu ON t.unit_id = mu.id
    WHERE t.user_id = ?
    ORDER BY t.date DESC
  ''', [userId]);
    if(results.isNotEmpty) {
      List resultList = results.map((row) {
        return {
          'transaction': {
            'id': row['transaction_id'],
            'amount': row['amount'],
            'quantity': row['quantity'],
            'price': row['price'],
            'place': row['place'] ?? '',
            'date': row['date'],
            'notes': row['notes'] ?? '',
          },
          'product': row['product_id'] != null ? {
            'id': row['product_id'],
            'subcategory_id': row['subcategory_id'],
            'name': row['product_name'],
            'description': row['product_description'],
            'common_unit': row['common_unit'],
          } : null,
          'subcategory': row['subcategory_id'] != null ? {
            'id': row['subcategory_id'],
            'category_id': row['category_id'],
            'name': row['subcategory_name'],
          } : null,
          'category': row['category_id'] != null ? {
            'id': row['category_id'],
            'name': row['category_name'],
            'icon': row['category_icon'],
            'color': row['category_color'],
          } : null,
          'measurement_units': row['unit_id'] != null ? {
            'id': row['unit_id'],
            'name': row['unit_name'] ?? '',
            'symbol': row['unit_symbol'] ?? '',
          } : null,
        };
      }).toList();
      return List.generate(resultList.length,
              (t) => AllTransactionDataModel.fromMap(resultList[t]));
    }
    return [];
  }

  @override
  Future<List<AllTransactionDataModel>> getUserAllTransactionDataRangeDate(
      String userId,
      DateTime startDate,
      DateTime endDate
      ) async {
    final db = await _appDatabase.db;
    final startString = startDate.toIso8601String();
    final endString = endDate.toIso8601String();

    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT 
      t.id AS transaction_id,
      t.amount,
      t.quantity,
      t.price,
      t.place,
      t.date,
      t.notes,
      t.unit_id,
      p.id AS product_id,
      p.name AS product_name,
      p.description AS product_description,
      p.common_unit,
      sc.id AS subcategory_id,
      sc.name AS subcategory_name,
      c.id AS category_id,
      c.name AS category_name,
      c.icon_name AS category_icon,
      c.color_hex AS category_color,
      mu.name AS unit_name,
      mu.symbol AS unit_symbol
    FROM transactions t
    LEFT JOIN products p ON t.product_id = p.id
    LEFT JOIN subcategories sc ON p.subcategory_id = sc.id
    LEFT JOIN categories c ON sc.category_id = c.id
    LEFT JOIN measurement_units mu ON t.unit_id = mu.id
    WHERE t.user_id = ? 
      AND t.date BETWEEN ? AND ?
    ORDER BY t.date DESC
  ''', [userId, startString, endString]);

    if(results.isNotEmpty) {
      List resultList = results.map((row) {
        return {
          'transaction': {
            'id': row['transaction_id'],
            'amount': row['amount'],
            'quantity': row['quantity'],
            'price': row['price'],
            'place': row['place'] ?? '',
            'date': row['date'],
            'notes': row['notes'] ?? '',
          },
          'product': row['product_id'] != null ? {
            'id': row['product_id'],
            'subcategory_id': row['subcategory_id'],
            'name': row['product_name'],
            'description': row['product_description'],
            'common_unit': row['common_unit'],
          } : null,
          'subcategory': row['subcategory_id'] != null ? {
            'id': row['subcategory_id'],
            'category_id': row['category_id'],
            'name': row['subcategory_name'],
          } : null,
          'category': row['category_id'] != null ? {
            'id': row['category_id'],
            'name': row['category_name'],
            'icon': row['category_icon'],
            'color': row['category_color'],
          } : null,
          'measurement_units': row['unit_id'] != null ? {
            'id': row['unit_id'],
            'name': row['unit_name'] ?? '',
            'symbol': row['unit_symbol'] ?? '',
          } : null,
        };
      }).toList();
      return List.generate(resultList.length,
              (t) => AllTransactionDataModel.fromMap(resultList[t]));
    }
    return [];
  }

  @override
  Future<List<AllTransactionDataModel>> getUserAllTransactionDataByDate(String userId, DateTime date) async {
    Database db = await _appDatabase.db;

    final dateString = date.toIso8601String().substring(0, 10);

    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT 
      t.id AS transaction_id,
      t.amount,
      t.quantity,
      t.price,
      t.place,
      t.date,
      t.notes,
      t.unit_id,
      p.id AS product_id,
      p.name AS product_name,
      p.description AS product_description,
      p.common_unit,
      sc.id AS subcategory_id,
      sc.name AS subcategory_name,
      c.id AS category_id,
      c.name AS category_name,
      c.icon_name AS category_icon,
      c.color_hex AS category_color,
      mu.name AS unit_name,
      mu.symbol AS unit_symbol
    FROM transactions t
    LEFT JOIN products p ON t.product_id = p.id
    LEFT JOIN subcategories sc ON p.subcategory_id = sc.id
    LEFT JOIN categories c ON sc.category_id = c.id
    LEFT JOIN measurement_units mu ON t.unit_id = mu.id
    WHERE t.user_id = ? 
      AND substr(t.date, 1, 10) = ?
    ORDER BY t.date DESC
  ''', [userId, dateString]);
    if(results.isNotEmpty) {
      List resultList = results.map((row) {
        return {
          'transaction': {
            'id': row['transaction_id'],
            'product_id': row['product_id'],
            'amount': row['amount'] ?? 0,
            'quantity': row['quantity'] ?? 0,
            'price': row['price'],
            'place': row['place'] ?? '',
            'date': row['date'],
            'notes': row['notes'] ?? '',
          },
          'product': row['product_id'] != null ? {
            'id': row['product_id'],
            'subcategory_id': row['subcategory_id'],
            'name': row['product_name'] ?? '',
            'description': row['product_description'] ?? '',
            'common_unit': row['common_unit'] ?? '',
          } : null,
          'subcategory': row['subcategory_id'] != null ? {
            'id': row['subcategory_id'],
            'category_id': row['category_id'],
            'name': row['subcategory_name'] ?? '',
          } : null,
          'category': row['category_id'] != null ? {
            'id': row['category_id'],
            'name': row['category_name'] ?? '',
            'icon': row['category_icon'] ?? '',
            'color': row['category_color'] ?? '',
          } : null,
          'measurement_units': row['unit_id'] != null ? {
            'id': row['unit_id'],
            'name': row['unit_name'] ?? '',
            'symbol': row['unit_symbol'] ?? '',
          } : null,
        };
      }).toList();
      return List.generate(resultList.length,
              (t) => AllTransactionDataModel.fromMap(resultList[t]));
    }
    return [];
  }

  // @override
  // Future<List<TransactionModel>> getUserTransactions(String userId) async {
  //   Database db = await _appDatabase.db;
  //   List<Map<String, dynamic>> productNameList = [];
  //
  //   final transactionList = await db.query(
  //     'transactions',
  //     where: 'user_id = ?',
  //     whereArgs: [userId],
  //   );
  //
  //   for(var transaction in transactionList){
  //     final productId = transaction['product_id'];
  //     if(productId != null){
  //       final w = await _iProductDao.getProductHierarchy(int.tryParse(productId.toString())!);
  //       productNameList.add(w);
  //     }
  //   }
  //
  //   return List.generate(transactionList.length,
  //     (t) => TransactionModel.fromMap(transactionList[t], productNameList[t]));
  //   }

  // Future<List<Map<String, dynamic>>> getTransactionsWithDetails(String userId) async {
  //   final db = await _appDatabase.db;
  //
  //   // Consulta SQL con múltiples JOINs para obtener todos los datos relacionados
  //   final List<Map<String, dynamic>> results = await db.rawQuery('''
  //   SELECT
  //     t.id AS transaction_id,
  //     t.amount,
  //     t.quantity,
  //     t.place,
  //     t.date,
  //     t.notes,
  //     p.id AS product_id,
  //     p.name AS product_name,
  //     p.description AS product_description,
  //     p.common_unit,
  //     sc.id AS subcategory_id,
  //     sc.name AS subcategory_name,
  //     c.id AS category_id,
  //     c.name AS category_name,
  //     c.icon_name AS category_icon,
  //     c.color_hex AS category_color,
  //     mu.name AS unit_name,
  //     mu.symbol AS unit_symbol
  //   FROM transactions t
  //   LEFT JOIN products p ON t.product_id = p.id
  //   LEFT JOIN subcategories sc ON p.subcategory_id = sc.id
  //   LEFT JOIN categories c ON sc.category_id = c.id
  //   LEFT JOIN measurement_units mu ON t.unit_id = mu.id
  //   WHERE t.user_id = ?
  //   ORDER BY t.date DESC
  // ''', [userId]);
  //
  //   // Mapear los resultados a una estructura más organizada
  //   return results.map((row) {
  //     return {
  //       'transaction': {
  //         'id': row['transaction_id'],
  //         'amount': row['amount'],
  //         'quantity': row['quantity'],
  //         'place': row['place'],
  //         'date': row['date'],
  //         'notes': row['notes'],
  //       },
  //       'product': row['product_id'] != null ? {
  //         'id': row['product_id'],
  //         'name': row['product_name'],
  //         'description': row['product_description'],
  //         'common_unit': row['common_unit'],
  //       } : null,
  //       'subcategory': row['subcategory_id'] != null ? {
  //         'id': row['subcategory_id'],
  //         'name': row['subcategory_name'],
  //       } : null,
  //       'category': row['category_id'] != null ? {
  //         'id': row['category_id'],
  //         'name': row['category_name'],
  //         'icon': row['category_icon'],
  //         'color': row['category_color'],
  //       } : null,
  //       'unit': row['unit_id'] != null ? {
  //         'name': row['unit_name'],
  //         'symbol': row['unit_symbol'],
  //       } : null,
  //     };
  //   }).toList();
  // }
}
