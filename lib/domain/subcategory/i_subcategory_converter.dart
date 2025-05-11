import 'package:gastos_app/domain/subcategory/subcategory_model.dart';


abstract class ISubcategoryConverter {

  SubcategoryModel fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(SubcategoryModel model);

}