class CategoryModel {
  final int? id;
  final String name;
  final String? iconName;
  final String? colorHex;

  CategoryModel({
    this.id,
    required this.name,
    this.iconName,
    this.colorHex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon_name': iconName,
      'color_hex': colorHex,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      iconName: map['icon_name'],
      colorHex: map['color_hex'],
    );
  }
}