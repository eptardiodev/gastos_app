import 'package:gastos_app/domain/list_item/list_item_model.dart';

abstract class IListItemDao {

  Future<int> insertListItem(ListItemModel item);

  Future<List<ListItemModel>> getItemsByList(int listId);

  Future<void> convertListToTransactions(int listId, String userId);
}
