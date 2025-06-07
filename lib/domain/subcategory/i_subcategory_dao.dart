import 'package:gastos_app/domain/subcategory/subcategory_model.dart';

abstract class ISubcategoryDao {

  Future<int> insertSubcategory(SubcategoryModel subcategory);

  Future<List<SubcategoryModel>> getSubcategoriesByCategory(int categoryId);

  Future<List<SubcategoryModel>> getAllSubcategory();

}
