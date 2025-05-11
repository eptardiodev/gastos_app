class TransactionModel {
  final int? id;
  final String userId;
  final int? productId;
  final double amount;
  final double? quantity;
  final int? unitId;
  final String? place;
  final DateTime date;
  final String? notes;

  TransactionModel({
    this.id,
    required this.userId,
    this.productId,
    required this.amount,
    this.quantity,
    this.unitId,
    this.place,
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'amount': amount,
      'quantity': quantity,
      'unit_id': unitId,
      'place': place,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      userId: map['user_id'],
      productId: map['product_id'],
      amount: map['amount'],
      quantity: map['quantity'],
      unitId: map['unit_id'],
      place: map['place'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }
}