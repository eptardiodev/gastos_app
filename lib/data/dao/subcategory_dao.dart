import 'package:gastos_app/data/local/app_database.dart';
import 'package:gastos_app/domain/subcategory/i_subcategory_dao.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';
import 'package:sqflite/sqflite.dart';


class SubcategoryDao implements ISubcategoryDao {
  final AppDatabase _appDatabase;

  SubcategoryDao(this._appDatabase);

  @override
  Future<int> insertSubcategory(SubcategoryModel subcategory) async {
    Database db = await _appDatabase.db;
    // Validar que la categoría padre exista
    final categoryExists = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [subcategory.categoryId],
    );
    if (categoryExists.isEmpty) throw Exception('Categoría padre no existe');

    return await db.insert('subcategories', subcategory.toMap());
  }

  @override
  Future<List<SubcategoryModel>> getSubcategoriesByCategory(int categoryId) async {
    Database db = await _appDatabase.db;
    final maps = await db.query(
      'subcategories',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return List.generate(maps.length, (i) => SubcategoryModel.fromMap(maps[i]));
  }

  @override
  Future<List<SubcategoryModel>> getAllSubcategory() async {
    Database db = await _appDatabase.db;
    final maps = await db.query('subcategories');
    return List.generate(maps.length, (i) => SubcategoryModel.fromMap(maps[i]));
  }

}
