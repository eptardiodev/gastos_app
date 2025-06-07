import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/data/repository/base_repository.dart';
import 'package:gastos_app/domain/list_item/i_list_item_dao.dart';
import 'package:gastos_app/domain/list_item/i_list_item_repository.dart';
import 'package:gastos_app/domain/list_item/list_item_model.dart';
import 'package:gastos_app/utils/logger.dart';

class ListItemRepository extends BaseRepository implements IListItemRepository {
  final Logger _logger;
  final IListItemDao _listItemDao;

  ListItemRepository(
      this._logger,
      this._listItemDao,
      );

  @override
  Future<Result<int>> insertListItem(ListItemModel item) async {
    try {
      final res = await _listItemDao.insertListItem(item);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en insertListItem: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<List<ListItemModel>>> getItemsByList(int listId) async {
    try {
      final res = await _listItemDao.getItemsByList(listId);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en getItemsByList: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<void>> convertListToTransactions(int listId, String userId) async {
    try {
      await _listItemDao.convertListToTransactions(listId, userId);
      return Result.success(value: null);
    } catch (ex) {
      _logger.log('Error en convertListToTransactions: $ex');
      return Result.error(error: ex);
    }
  }

}