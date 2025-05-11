import 'package:gastos_app/domain/list_item/list_item_model.dart';

abstract class IListItemConverter {

  ListItemModel fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(ListItemModel model);

}