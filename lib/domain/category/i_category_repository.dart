import 'dart:core';

import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/domain/category/category_model.dart';

abstract class ICategoryRepository {

  Future<Result<List<CategoryModel>>> getAllCategories();

  Future<Result<int>> insertCategory(CategoryModel category);

  Future<Result<int>> updateCategory(CategoryModel category);

  Future<Result<int>> deleteCategory(int id);

  Future<Result<CategoryModel?>> getCategoryById(int id);

}
