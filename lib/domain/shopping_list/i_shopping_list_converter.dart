import 'package:gastos_app/domain/shopping_list/shopping_list_model.dart';


abstract class IShoppingListConverter {

  ShoppingListModel fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(ShoppingListModel model);

}