import 'package:gastos_app/domain/list_template/list_template_model.dart';

abstract class IListTemplateDao {
  Future<int> insertListTemplate(ListTemplateModel template);
  Future<List<ListTemplateModel>> getUserListTemplates(String userId);
  Future<int> deleteListTemplate(int id);
}