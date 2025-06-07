import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';

abstract class ISubcategoryRepository {

  Future<Result<int>> insertSubcategory(SubcategoryModel subcategory);

  Future<Result<List<SubcategoryModel>>> getSubcategoriesByCategory(int categoryId);

  Future<Result<List<SubcategoryModel>>> getAllSubcategory();

}