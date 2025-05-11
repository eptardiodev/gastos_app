import 'package:gastos_app/domain/category/category_model.dart';


abstract class ICategoryConverter {

  CategoryModel fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(CategoryModel model);

}