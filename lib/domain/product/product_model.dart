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
      'subcategory_id': subcategoryId,
      'name': name,
      'description': description ?? '',
      'common_unit': commonUnit ?? '',
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      subcategoryId: map['subcategory_id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      commonUnit: map['common_unit'] ?? '',
    );
  }
}