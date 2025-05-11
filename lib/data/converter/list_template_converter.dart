import 'package:gastos_app/data/remote/remote_constants.dart';
import 'package:gastos_app/domain/list_template/i_list_template_converter.dart';
import 'package:gastos_app/domain/list_template/list_template_model.dart';


class ListTemplateConverter implements IListTemplateConverter{

  @override
  ListTemplateModel fromJson(Map<String, dynamic> json) {
    return ListTemplateModel(
      name: '',
      userId: '',
    );
  }

  @override
  Map<String, dynamic> toJson(ListTemplateModel model) {
    return {
      RemoteConstants.name: model.name,
      
    };
  }
}
