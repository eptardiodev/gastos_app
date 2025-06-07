import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/data/repository/base_repository.dart';
import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/category/i_category_dao.dart';
import 'package:gastos_app/domain/category/i_category_repository.dart';
import 'package:gastos_app/utils/logger.dart';

class CategoryRepository extends BaseRepository implements ICategoryRepository {
  final Logger _logger;
  final ICategoryDao _iCategoryDao;

  CategoryRepository(
      this._logger,
      this._iCategoryDao,
      );

  @override
  Future<Result<List<CategoryModel>>> getAllCategories() async {
    try {
      final res = await _iCategoryDao.getAllCategories();
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en getAllCategories: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<int>> insertCategory(CategoryModel category) async {
    try {
      final res = await _iCategoryDao.insertCategoryModel(category);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en insertCategory: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<int>> updateCategory(CategoryModel category) async {
    try {
      final res = await _iCategoryDao.updateCategoryModel(category);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en updateCategory: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<int>> deleteCategory(int id) async {
    try {
      final res = await _iCategoryDao.deleteCategoryModel(id);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en deleteCategory: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<CategoryModel?>> getCategoryById(int id) async {
    try {
      final allCategories = await _iCategoryDao.getAllCategories();
      final category = allCategories.firstWhere(
            (c) => c.id == id,
        orElse: () => null as CategoryModel,
      );
      return Result.success(value: category);
    } catch (ex) {
      _logger.log('Error en getCategoryById: $ex');
      return Result.error(error: ex);
    }
  }
}