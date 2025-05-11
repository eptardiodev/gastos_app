import 'package:gastos_app/domain/product/product_model.dart';

abstract class IProductDao {
  Future<int> insertProduct(ProductModel product);

  Future<List<ProductModel>> getProductsBySubcategory(int subcategoryId);

  Future<Map<String, dynamic>> getProductHierarchy(int productId);


}
