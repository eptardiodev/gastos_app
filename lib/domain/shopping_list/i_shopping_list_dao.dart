import 'package:gastos_app/domain/shopping_list/shopping_list_model.dart';

abstract class IShoppingListDao {

  Future<int> insertShoppingList(ShoppingListModel list);

  Future<List<ShoppingListModel>> getUserShoppingLists(String userId);
}
