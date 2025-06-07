import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/data/repository/base_repository.dart';
import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/product/i_product_dao.dart';
import 'package:gastos_app/domain/product/i_product_repository.dart';
import 'package:gastos_app/domain/product/product_model.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';
import 'package:gastos_app/utils/logger.dart';

class ProductRepository extends BaseRepository implements IProductRepository {
  final Logger _logger;
  final IProductDao _productDao;

  ProductRepository(
      this._logger,
      this._productDao,
      );

  @override
  Future<Result<int>> insertProduct(ProductModel product) async {
    try {
      final res = await _productDao.insertProduct(product);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en insertProduct: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<List<ProductModel>>> getProductsBySubcategory(int subcategoryId) async {
    try {
      final res = await _productDao.getProductsBySubcategory(subcategoryId);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en getProductsBySubcategory: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> getProductHierarchy(int productId) async {
    try {
      final res = await _productDao.getProductHierarchy(productId);
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en getProductHierarchy: $ex');
      return Result.error(error: ex);
    }
  }

  @override
  Future<Result<List<ProductModel>>> getAllProduct() async {
    try {
      final res = await _productDao.getAllProduct();
      return Result.success(value: res);
    } catch (ex) {
      _logger.log('Error en getAllProduct: $ex');
      return Result.error(error: ex);
    }
  }

}