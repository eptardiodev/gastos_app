import 'package:gastos_app/data/local/app_database.dart';
import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/product/i_product_dao.dart';
import 'package:gastos_app/domain/product/product_model.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';
import 'package:sqflite/sqflite.dart';


class ProductDao implements IProductDao {
  final AppDatabase _appDatabase;

  ProductDao(this._appDatabase);

  @override
  Future<int> insertProduct(ProductModel product) async {
    Database db = await _appDatabase.db;

    final subcategoryExists = await db.query(
      'subcategories',
      where: 'id = ?',
      whereArgs: [product.subcategoryId],
    );

    if (subcategoryExists.isEmpty) {
      throw Exception('La subcategoría no existe');
    }

    return await db.insert('products', product.toMap());
  }

  @override
  Future<List<ProductModel>> getProductsBySubcategory(int subcategoryId) async {
    Database db = await _appDatabase.db;
    final maps = await db.query(
      'products',
      where: 'subcategory_id = ?',
      whereArgs: [subcategoryId],
    );

    return List.generate(maps.length, (i) {
      return ProductModel.fromMap(maps[i]);
    });
  }

  @override
  Future<Map<String, dynamic>> getProductHierarchy(int productId) async {
    Database db = await _appDatabase.db;

    final product = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );
    if (product.isEmpty) throw Exception('Producto no existe');

    final subcategory = await db.query(
      'subcategories',
      where: 'id = ?',
      whereArgs: [product.first['subcategory_id']],
    );

    final category = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [subcategory.first['category_id']],
    );

    return {
      'product': ProductModel.fromMap(product.first),
      'subcategory': SubcategoryModel.fromMap(subcategory.first),
      'category': CategoryModel.fromMap(category.first),
    };
  }

  @override
  Future<List<ProductModel>> getAllProduct() async {
    Database db = await _appDatabase.db;
    final maps = await db.query('products');

    return List.generate(maps.length, (i) {
      var m = maps[i];
      return ProductModel.fromMap(m);
    });
  }

}
