import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/data/repository/base_repository.dart';
import 'package:gastos_app/domain/product_with_category/i_product_with_category.dart';
import 'package:gastos_app/domain/product_with_category/i_product_with_category_dao.dart';
import 'package:gastos_app/domain/product_with_category/product_with_category_model.dart';
import 'package:gastos_app/utils/logger.dart';

class ProductWithCategoryRepository extends BaseRepository implements IProductWithCategoryRepository {
  final Logger _logger;
  final IProductWithCategoryDao _productWithCategoryDao;

  ProductWithCategoryRepository(
      this._logger,
      this._productWithCategoryDao,
      );

  @override
  Future<Result<ProductWithCategoryModel>> getProductWithCategory(int productId) async {
    try {
      final res = await _productWithCategoryDao.getProductWithCategory(productId);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en getProductWithCategory: $ex');
      return Result.error(error: ex);
    }
  }
}