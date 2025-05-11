import 'package:gastos_app/data/local/app_database.dart';
import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/product/product_model.dart';
import 'package:gastos_app/domain/product_with_category/i_product_with_category_dao.dart';
import 'package:gastos_app/domain/product_with_category/product_with_category_model.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductWithCategoryDao implements IProductWithCategoryDao {
  final AppDatabase _appDatabase;


  ProductWithCategoryDao(this._appDatabase);

  @override
  Future<ProductWithCategoryModel> getProductWithCategory(int productId) async {
    Database db = await _appDatabase.db;

    final productMap = (await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    )).first;

    final subcategoryMap = (await db.query(
      'subcategories',
      where: 'id = ?',
      whereArgs: [productMap['subcategory_id']],
    )).first;

    final categoryMap = (await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [subcategoryMap['category_id']],
    )).first;

    return ProductWithCategoryModel(
      product: ProductModel.fromMap(productMap),
      subcategory: SubcategoryModel.fromMap(subcategoryMap),
      category: CategoryModel.fromMap(categoryMap),
    );
  }
}
