import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/domain/list_template/list_template_model.dart';

abstract class IListTemplateRepository {
  Future<Result<int>> insertListTemplate(ListTemplateModel template);
  Future<Result<List<ListTemplateModel>>> getUserListTemplates(String userId);
  Future<Result<int>> deleteListTemplate(int id);
}