class MeasurementUnitModel {
  final int? id;
  final String name;
  final String symbol;

  MeasurementUnitModel({
    this.id,
    required this.name,
    required this.symbol,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name ?? '',
      'symbol': symbol ?? '',
    };
  }

  factory MeasurementUnitModel.fromMap(Map<String, dynamic> map) {
    return MeasurementUnitModel(
      id: map['id'],
      name: map['name'] ?? '',
      symbol: map['symbol'] ?? '',
    );
  }
}