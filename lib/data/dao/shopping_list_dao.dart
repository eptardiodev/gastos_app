import 'package:gastos_app/data/local/app_database.dart';
import 'package:gastos_app/domain/shopping_list/i_shopping_list_dao.dart';
import 'package:gastos_app/domain/shopping_list/shopping_list_model.dart';
import 'package:sqflite/sqflite.dart';


class ShoppingListDao implements IShoppingListDao {
  final AppDatabase _appDatabase;

  ShoppingListDao(this._appDatabase);

  @override
  Future<int> insertShoppingList(ShoppingListModel list) async {
    Database db = await _appDatabase.db;

    return await db.insert('shopping_lists', list.toMap());
  }

  @override
  Future<List<ShoppingListModel>> getUserShoppingLists(String userId) async {
    Database db = await _appDatabase.db;

    final maps = await db.query(
      'shopping_lists',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => ShoppingListModel.fromMap(maps[i]));
  }
}
