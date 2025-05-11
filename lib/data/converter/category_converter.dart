import 'package:gastos_app/data/remote/remote_constants.dart';
import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/category/i_category_converter.dart';

class CategoryConverter implements ICategoryConverter{

  @override
  CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: '',

        );
  }

  @override
  Map<String, dynamic> toJson(CategoryModel model) {
    return {
      RemoteConstants.name: model.name,
      
    };
  }
}
