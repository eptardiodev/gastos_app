import 'package:gastos_app/data/remote/remote_constants.dart';
import 'package:gastos_app/domain/subcategory/i_subcategory_converter.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';

class SubcategoryConverter implements ISubcategoryConverter{

  @override
  SubcategoryModel fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      name: '', categoryId: 2,

        );
  }

  @override
  Map<String, dynamic> toJson(SubcategoryModel model) {
    return {
      RemoteConstants.name: model.name,
      
    };
  }
}
