import 'package:gastos_app/domain/category/category_model.dart';

abstract class ICategoryDao {

  Future<int> insertCategoryModel(CategoryModel category);

  Future<List<CategoryModel>> getAllCategories();

  Future<int> updateCategoryModel(CategoryModel category);

  Future<int> deleteCategoryModel(int id);


}
