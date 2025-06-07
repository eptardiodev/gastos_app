import 'package:gastos_app/data/local/app_database.dart';
import 'package:gastos_app/domain/list_template/i_list_template_dao.dart';
import 'package:gastos_app/domain/list_template/list_template_model.dart';
import 'package:sqflite/sqflite.dart';

class ListTemplateDao implements IListTemplateDao {
  final AppDatabase _appDatabase;

  ListTemplateDao(this._appDatabase);

  @override
  Future<int> insertListTemplate(ListTemplateModel template) async {
    final db = await _appDatabase.db;
    return await db.insert('list_templates', template.toMap());
  }

  @override
  Future<List<ListTemplateModel>> getUserListTemplates(String userId) async {
    final db = await _appDatabase.db;
    final maps = await db.query(
      'list_templates',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => ListTemplateModel.fromMap(maps[i]));
  }

  @override
  Future<int> deleteListTemplate(int id) async {
    final db = await _appDatabase.db;
    return await db.delete(
      'list_templates',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}