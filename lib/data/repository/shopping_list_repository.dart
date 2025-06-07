import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/data/repository/base_repository.dart';
import 'package:gastos_app/domain/shopping_list/i_shopping_list_dao.dart';
import 'package:gastos_app/domain/shopping_list/i_shopping_list_repository.dart';
import 'package:gastos_app/domain/shopping_list/shopping_list_model.dart';
import 'package:gastos_app/utils/logger.dart';

class ShoppingListRepository extends BaseRepository implements IShoppingListRepository {
  final Logger _logger;
  final IShoppingListDao _shoppingListDao;

  ShoppingListRepository(
      this._logger,
      this._shoppingListDao,
      );

  @override
  Future<Result<int>> insertShoppingList(ShoppingListModel list) async {
    try {
      final res = await _shoppingListDao.insertShoppingList(list);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en insertShoppingList: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<List<ShoppingListModel>>> getUserShoppingLists(String userId) async {
    try {
      final res = await _shoppingListDao.getUserShoppingLists(userId);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en getUserShoppingLists: $ex');
      return Result.error(error: ex);
    }
  }
}