class SubcategoryModel {
  final int? id;
  final int categoryId;
  final String name;

  SubcategoryModel({
    this.id,
    required this.categoryId,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
    };
  }

  factory SubcategoryModel.fromMap(Map<String, dynamic> map) {
    return SubcategoryModel(
      id: map['id'],
      categoryId: map['category_id'],
      name: map['name'],
    );
  }
}