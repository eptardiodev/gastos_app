class ExpenseModel {

  DateTime? date;
  String? product;
  double? price;
  int? amount;

  /// aqui no se declaran con final, porque si pones final a una variable estas
  /// indicando que esa variable finalmente vale tal cosa.
  /// entonces estas variables van a usarse en multiples lugares y usos diferen-
  /// tes
  /// si no le pones nada pues se queda abierta a multiples usos
  /// estudiar lo que significa final, late, y otros mas


  ExpenseModel({
    this.date,
    this.product,
    this.price,
    this.amount
  });

}
