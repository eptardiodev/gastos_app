import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/domain/product/product_model.dart';

abstract class IProductRepository {
  Future<Result<int>> insertProduct(ProductModel product);

  Future<Result<List<ProductModel>>> getProductsBySubcategory(int subcategoryId);

  Future<Result<Map<String, dynamic>>> getProductHierarchy(int productId);

  Future<Result<List<ProductModel>>> getAllProduct();

}