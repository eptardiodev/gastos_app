import 'dart:core';

import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/domain/list_item/list_item_model.dart';

abstract class IListItemRepository {

  Future<Result<int>> insertListItem(ListItemModel item);

  Future<Result<List<ListItemModel>>> getItemsByList(int listId);

  Future<Result<void>> convertListToTransactions(int listId, String userId);

}
