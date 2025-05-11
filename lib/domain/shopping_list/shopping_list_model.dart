class ShoppingListModel {
  final int? id;
  final String userId;
  final String name;
  final DateTime createdAt;
  final DateTime? lastUsed;

  ShoppingListModel({
    this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    this.lastUsed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'last_used': lastUsed?.toIso8601String(),
    };
  }

  factory ShoppingListModel.fromMap(Map<String, dynamic> map) {
    return ShoppingListModel(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      createdAt: DateTime.parse(map['created_at']),
      lastUsed: map['last_used'] != null ? DateTime.parse(map['last_used']) : null,
    );
  }
}