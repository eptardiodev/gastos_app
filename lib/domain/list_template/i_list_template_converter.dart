import 'package:gastos_app/domain/list_template/list_template_model.dart';


abstract class IListTemplateConverter {

  ListTemplateModel fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(ListTemplateModel model);

}