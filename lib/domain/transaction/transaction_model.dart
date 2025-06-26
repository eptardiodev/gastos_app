import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/measurement_unit_model/measurement_unit_model.dart';
import 'package:gastos_app/domain/product/product_model.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';

class TransactionModel {
  final int? id;
  final String userId;
  int? productId;

  // String? productName;
  // int? categoryId;
  // String? categoryName;
  // int? subcategoryId;
  // String? subcategoryName;

  double amount;
  double? quantity;
  double? price;
  String? notes;
  DateTime date;
  String? place;
  int? unitId;

  bool? selected;


  TransactionModel({
    this.id,
    required this.userId,
    required this.amount,
    this.productId,

    // this.productName,
    // this.categoryId,
    // this.categoryName,
    // this.subcategoryId,
    // this.subcategoryName,

    this.quantity,
    this.price,
    this.unitId,
    this.place,
    required this.date,
    this.notes,
    this.selected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'amount': amount ?? 0,
      'quantity': quantity ?? 0,
      'price': price ?? 0,
      'unit_id': unitId ?? 0,
      'place': place ?? '',
      'date': date.toIso8601String(),
      'notes': notes ?? '',
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      userId: map['user_id'] ?? "12",
      productId: map['product_id'],
      amount: map['amount'] ?? 0,
      quantity: map['quantity'] ?? 0,
      price: map['price'] ?? 0,
      unitId: map['unit_id'] ?? 0,
      place: map['place'] ?? '',
      date: DateTime.parse(map['date']),
      notes: map['notes'] ?? '',
    );
  }
}
// transaction': {
// 'id': row['transaction_id'],
// 'amount': row['amount'],
// 'quantity': row['quantity'],
// 'place': row['place'],
// 'date': row['date'],
// 'notes': row['notes'],
// },
// 'product': row['product_id'] != null ? {
// 'id': row['product_id'],
// 'name': row['product_name'],
// 'description': row['product_description'],
// 'common_unit': row['common_unit'],
// } : null,
// 'subcategory': row['subcategory_id'] != null ? {
// 'id': row['subcategory_id'],
// 'name': row['subcategory_name'],
// } : null,
// 'category': row['category_id'] != null ? {
// 'id': row['category_id'],
// 'name': row['category_name'],
// 'icon': row['category_icon'],
// 'color': row['category_color'],
// } : null,
// 'unit': row['unit_id'] != null ? {
// 'name': row['unit_name'],
// 'symbol': row['unit_symbol'],
// } : null,

class AllTransactionDataModel{
  TransactionModel? transaction;
  final ProductModel? product;
  final CategoryModel? category;
  final SubcategoryModel? subcategory;
  final MeasurementUnitModel? measurementUnitModel;
  AllTransactionDataModel({
    this.transaction,
    this.product,
    this.category,
    this.subcategory,
    this.measurementUnitModel,
  });

  Map<String, dynamic> toMap(AllTransactionDataModel allData) {
    return {
      'transaction': {
        'id': allData.transaction!.id,
        'user_id': allData.transaction!.userId,
        'product_id': allData.transaction!.productId,
        'amount': allData.transaction!.amount ?? 0,
        'quantity': allData.transaction!.quantity ?? 0,
        'price': allData.transaction!.price ?? 0,
        'unit_id': allData.transaction!.unitId ?? 0,
        'place': allData.transaction!.place ?? '',
        'date': allData.transaction!.date.toIso8601String(),
        'notes': allData.transaction!.notes ?? '',
      },
      'product': {
        'id': allData.product!.id,
        'subcategory_id': allData.product!.subcategoryId,
        'name': allData.product!.name,
        'description': allData.product!.description,
        'common_unit': allData.product!.commonUnit,
      },
      'category': {
        'id': allData.category!.id,
        'name': allData.category!.name,
        'icon_name': allData.category!.iconName,
        'color_hex': allData.category!.colorHex,
      },
      'subcategory': {
        'id': allData.subcategory!.id,
        'category_id': allData.subcategory!.categoryId,
        'name': allData.subcategory!.name,
      },
      'measurement_units': {
        'id': allData.measurementUnitModel!.id,
        'name': allData.measurementUnitModel!.name,
        'symbol': allData.measurementUnitModel!.symbol,
      }
    };
  }

  factory AllTransactionDataModel.fromMap(Map<String, dynamic> map) {
    return AllTransactionDataModel(
      transaction: TransactionModel.fromMap(map['transaction']),
      product: ProductModel.fromMap(map['product']),
      category: CategoryModel.fromMap(map['category']),
      subcategory: SubcategoryModel.fromMap(map['subcategory']),
      measurementUnitModel: MeasurementUnitModel.fromMap(map['measurement_units'] ?? {}),
    );
  }
}