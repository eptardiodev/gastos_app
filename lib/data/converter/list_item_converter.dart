import 'package:gastos_app/domain/list_item/i_list_item_converter.dart';
import 'package:gastos_app/domain/list_item/list_item_model.dart';


class ListItemConverter implements IListItemConverter{

  @override
  ListItemModel fromJson(Map<String, dynamic> json) {
    return ListItemModel(
      addedAt: DateTime.now(),
      productId: 12,
      isChecked: true,
      listId: 2,
    );
  }

  @override
  Map<String, dynamic> toJson(ListItemModel model) {
    return {

      
    };
  }
}
