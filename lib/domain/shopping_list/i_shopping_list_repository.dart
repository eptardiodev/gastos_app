import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/domain/shopping_list/shopping_list_model.dart';

abstract class IShoppingListRepository {
  Future<Result<int>> insertShoppingList(ShoppingListModel list);
  Future<Result<List<ShoppingListModel>>> getUserShoppingLists(String userId);
}