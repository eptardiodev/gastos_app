import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/product/product_model.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';

class ProductWithCategoryModel {
  final ProductModel product;
  final SubcategoryModel subcategory;
  final CategoryModel category;

  ProductWithCategoryModel({
    required this.product,
    required this.subcategory,
    required this.category,
  });
}