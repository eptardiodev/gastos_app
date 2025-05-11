class ProductModel {
  final int? id;
  final int subcategoryId;
  final String name;
  final String? description;
  final String? commonUnit;

  ProductModel({
    this.id,
    required this.subcategoryId,
    required this.name,
    this.description,
    this.commonUnit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subcategoryId': subcategoryId,
      'name': name,
      'description': description,
      'common_unit': commonUnit,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      subcategoryId: map['subcategoryId'],
      name: map['name'],
      description: map['description'],
      commonUnit: map['common_unit'],
    );
  }
}