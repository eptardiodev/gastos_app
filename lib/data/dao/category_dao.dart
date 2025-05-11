import 'package:gastos_app/data/local/app_database.dart';
import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/category/i_category_dao.dart';
import 'package:sqflite/sqflite.dart';


class CategoryDao implements ICategoryDao {
  final AppDatabase _appDatabase;

  CategoryDao(this._appDatabase);

  @override
  Future<int> insertCategoryModel(CategoryModel category) async {
    Database db = await _appDatabase.db;
    return await db.insert('categories', category.toMap());
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    Database db = await _appDatabase.db;
    final maps = await db.query('categories');
    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  @override
  Future<int> updateCategoryModel(CategoryModel category) async {
    Database db = await _appDatabase.db;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<int> deleteCategoryModel(int id) async {
    Database db = await _appDatabase.db;
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
}
