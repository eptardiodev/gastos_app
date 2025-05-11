class ListItemModel {
  final int? id;
  final int listId;
  final int productId;
  final double? quantity;
  final int? unitId;
  final bool isChecked;
  final DateTime addedAt;

  ListItemModel({
    this.id,
    required this.listId,
    required this.productId,
    this.quantity,
    this.unitId,
    this.isChecked = false,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'list_id': listId,
      'product_id': productId,
      'quantity': quantity,
      'unit_id': unitId,
      'is_checked': isChecked ? 1 : 0,
      'added_at': addedAt.toIso8601String(),
    };
  }

  factory ListItemModel.fromMap(Map<String, dynamic> map) {
    return ListItemModel(
      id: map['id'],
      listId: map['list_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      unitId: map['unit_id'],
      isChecked: map['is_checked'] == 1,
      addedAt: DateTime.parse(map['added_at']),
    );
  }
}