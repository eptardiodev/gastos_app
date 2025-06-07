import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/data/repository/base_repository.dart';
import 'package:gastos_app/domain/subcategory/i_subcategory_dao.dart';
import 'package:gastos_app/domain/subcategory/i_subcategory_repository.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';
import 'package:gastos_app/utils/logger.dart';

class SubcategoryRepository extends BaseRepository implements ISubcategoryRepository {
  final Logger _logger;
  final ISubcategoryDao _subcategoryDao;

  SubcategoryRepository(
      this._logger,
      this._subcategoryDao,
      );

  @override
  Future<Result<int>> insertSubcategory(SubcategoryModel subcategory) async {
    try {
      final res = await _subcategoryDao.insertSubcategory(subcategory);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en insertSubcategory: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<List<SubcategoryModel>>> getSubcategoriesByCategory(int categoryId) async {
    try {
      final res = await _subcategoryDao.getSubcategoriesByCategory(categoryId);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en getSubcategoriesByCategory: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<List<SubcategoryModel>>> getAllSubcategory() async {
    try {
      final res = await _subcategoryDao.getAllSubcategory();
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en getSubcategoriesByCategory: $ex');
      return Result.error(error: ex);
    }
  }
}