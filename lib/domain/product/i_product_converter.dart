import 'package:gastos_app/domain/product/product_model.dart';


abstract class IProductConverter {

  ProductModel fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(ProductModel model);

}