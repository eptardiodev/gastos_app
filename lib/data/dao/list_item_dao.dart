import 'package:gastos_app/data/local/app_database.dart';
import 'package:gastos_app/domain/list_item/i_list_item_dao.dart';
import 'package:gastos_app/domain/list_item/list_item_model.dart';
import 'package:sqflite/sqflite.dart';


class ListItemDao implements IListItemDao {
  final AppDatabase _appDatabase;

  ListItemDao(this._appDatabase);

  @override
  Future<int> insertListItem(ListItemModel item) async {
    Database db = await _appDatabase.db;

    final listExists = await db.query(
      'shopping_lists',
      where: 'id = ?',
      whereArgs: [item.listId],
    );
    final productExists = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [item.productId],
    );
    if (listExists.isEmpty || productExists.isEmpty) {
      throw Exception('Lista o producto no existen');
    }

    return await db.insert('list_items', item.toMap());
  }


  @override
  Future<List<ListItemModel>> getItemsByList(int listId) async {
    Database db = await _appDatabase.db;
    final maps = await db.query(
      'list_items',
      where: 'list_id = ?',
      whereArgs: [listId],
    );
    return List.generate(maps.length, (i) => ListItemModel.fromMap(maps[i]));
  }

  @override
  Future<void> convertListToTransactions(int listId, String userId) async {
    Database db = await _appDatabase.db;
    final items = await getItemsByList(listId);

    await db.transaction((txn) async {
      for (final item in items.where((i) => i.isChecked)) {
        await txn.insert('transactions', {
          'user_id': userId,
          'product_id': item.productId,
          'amount': 0, // Ajustar según lógica de precios
          'quantity': item.quantity,
          'unit_id': item.unitId,
          'date': DateTime.now().toIso8601String(),
        });
      }
    });
  }
}
