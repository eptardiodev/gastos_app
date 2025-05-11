import 'package:gastos_app/data/remote/remote_constants.dart';
import 'package:gastos_app/domain/shopping_list/i_shopping_list_converter.dart';
import 'package:gastos_app/domain/shopping_list/shopping_list_model.dart';

class ShoppingListConverter implements IShoppingListConverter{

  @override
  ShoppingListModel fromJson(Map<String, dynamic> json) {
    return ShoppingListModel(
      name: "quitar",
      createdAt: DateTime.now(),
      userId: "12",
    );
  }

  @override
  Map<String, dynamic> toJson(ShoppingListModel model) {
    return {
      RemoteConstants.name: model.name,
      
    };
  }
}
