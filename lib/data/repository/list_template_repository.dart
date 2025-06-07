import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/data/repository/base_repository.dart';
import 'package:gastos_app/domain/list_template/i_list_template_dao.dart';
import 'package:gastos_app/domain/list_template/i_list_template_repository.dart';
import 'package:gastos_app/domain/list_template/list_template_model.dart';
import 'package:gastos_app/utils/logger.dart';

class ListTemplateRepository extends BaseRepository implements IListTemplateRepository {
  final Logger _logger;
  final IListTemplateDao _listTemplateDao;

  ListTemplateRepository(
      this._logger,
      this._listTemplateDao,
      );

  @override
  Future<Result<int>> insertListTemplate(ListTemplateModel template) async {
    try {
      final res = await _listTemplateDao.insertListTemplate(template);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en insertListTemplate: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<List<ListTemplateModel>>> getUserListTemplates(String userId) async {
    try {
      final res = await _listTemplateDao.getUserListTemplates(userId);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en getUserListTemplates: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<int>> deleteListTemplate(int id) async {
    try {
      final res = await _listTemplateDao.deleteListTemplate(id);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en deleteListTemplate: $ex');
      return Result.error(error: ex);
    }
  }
}