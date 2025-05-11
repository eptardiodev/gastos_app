import 'package:gastos_app/data/remote/remote_constants.dart';
import 'package:gastos_app/domain/product/i_product_converter.dart';
import 'package:gastos_app/domain/product/product_model.dart';


class ProductConverter implements IProductConverter{

  @override
  ProductModel fromJson(Map<String, dynamic> json) {
    return ProductModel(
      subcategoryId: 2,
      name: '',
    );
  }

  @override
  Map<String, dynamic> toJson(ProductModel model) {
    return {
      RemoteConstants.name: model.name,
      
    };
  }
}
