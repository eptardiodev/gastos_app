import 'package:gastos_app/domain/product_with_category/product_with_category_model.dart';


abstract class IProductWithCategoryDao {
  Future<ProductWithCategoryModel> getProductWithCategory(int productId);
}
