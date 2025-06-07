import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/domain/product_with_category/product_with_category_model.dart';

abstract class IProductWithCategoryRepository {
  Future<Result<ProductWithCategoryModel>> getProductWithCategory(int productId);
}