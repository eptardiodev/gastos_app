import 'package:gastos_app/base/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:gastos_app/data/remote/result.dart';
import 'package:gastos_app/domain/category/category_model.dart';
import 'package:gastos_app/domain/category/i_category_dao.dart';
import 'package:gastos_app/domain/category/i_category_repository.dart';
import 'package:gastos_app/domain/expense/expense_model.dart';
import 'package:gastos_app/domain/expense/i_expense_repository.dart';
import 'package:gastos_app/domain/product/i_product_repository.dart';
import 'package:gastos_app/domain/product/product_model.dart';
import 'package:gastos_app/domain/subcategory/i_subcategory_repository.dart';
import 'package:gastos_app/domain/subcategory/subcategory_model.dart';
import 'package:gastos_app/domain/transaction/i_transaction_repository.dart';
import 'package:gastos_app/domain/transaction/transaction_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:gastos_app/base/bloc_base.dart';
import '../../base/loading_handler.dart';

class HomeBloC extends BaseBloC with LoadingHandler, ErrorHandler {

  final ITransactionRepository _iTransactionRepository;
  final IExpenseRepository _iExpenseRepository;
  final ICategoryRepository _iCategoryRepository;
  final ISubcategoryRepository _iSubCategoryRepository;
  final IProductRepository _iProductRepository;

  HomeBloC(
    this._iTransactionRepository,
    this._iExpenseRepository,
    this._iCategoryRepository,
    this._iSubCategoryRepository,
    this._iProductRepository,
  );

  // final BehaviorSubject<List<ExpenseModel>> _expenseListSubject = BehaviorSubject();
  //
  // Stream<List<ExpenseModel>> get expenseListStream => _expenseListSubject.stream;

  final BehaviorSubject<List<AllTransactionDataModel>> _transactionListSubject = BehaviorSubject();

  Stream<List<AllTransactionDataModel>> get transactionListStream => _transactionListSubject.stream;

  final BehaviorSubject<List<CategoryModel>> _categoryListSubject = BehaviorSubject();

  Stream<List<CategoryModel>> get categoryListStream => _categoryListSubject.stream;

  final BehaviorSubject<List<SubcategoryModel>> _subcategoryListSubject = BehaviorSubject();

  Stream<List<SubcategoryModel>> get subcategoryListStream => _subcategoryListSubject.stream;

  final BehaviorSubject<List<ProductModel>> _productListSubject = BehaviorSubject();

  Stream<List<ProductModel>> get productListStream => _productListSubject.stream;

  void init({
    required DateTime date
  }){
    getAllCategories();
    getAllTransactionDataByDate(date);
    // getAllTransaction();
  }

  Future<List<CategoryModel>> getAllCategories() async {
    List<CategoryModel> categoryList = [];
    final res = await _iCategoryRepository.getAllCategories();
    if (res is ResultSuccess<List<CategoryModel>>) {
      categoryList = res.value;
    }
    _categoryListSubject.sink.add(categoryList);
    return categoryList;
  }

  Future<List<SubcategoryModel>> getAllSubCategories() async {
    List<SubcategoryModel> subcategoryList = [];
    final res = await _iSubCategoryRepository.getAllSubcategory();
    if (res is ResultSuccess<List<SubcategoryModel>>) {
      subcategoryList = res.value;
    }
    _subcategoryListSubject.sink.add(subcategoryList);
    return subcategoryList;
  }

  Future<List<ProductModel>> getAllProduct() async {
    List<ProductModel> productList = [];
    final res = await _iProductRepository.getAllProduct();
    if (res is ResultSuccess<List<ProductModel>>) {
      productList = res.value;
    }
    _productListSubject.sink.add(productList);
    return productList;
  }



  void getAllTransaction() async {
    List<AllTransactionDataModel> transactionList = [];
    final res = await _iTransactionRepository.getUserAllTransactionData("12");
    if (res is ResultSuccess<List<AllTransactionDataModel>>) {
      transactionList = res.value;
    }
    _transactionListSubject.sink.add(transactionList);
  }

  Future<void> getAllTransactionDataByDate(DateTime date) async {
    List<AllTransactionDataModel> transactionList = [];
    final res = await _iTransactionRepository.getUserAllTransactionDataByDate("12", date);
    if (res is ResultSuccess<List<AllTransactionDataModel>>) {
      transactionList = res.value;
    }
    _transactionListSubject.sink.add(transactionList);
  }

  // Future<void> saveTransaction(TransactionModel transaction) async {
  //   final res = await _iTransactionRepository.insertTransaction(transaction);
  //   if (res is ResultSuccess<int>) {
  //     List<TransactionModel> transactionList = _transactionListSubject.value.toList();
  //     transactionList.add(transaction);
  //     _transactionListSubject.sink.add(transactionList);
  //   }
  // }

  // void getAllExpenses() async {
  //   List<ExpenseModel> expenseList = [];
  //   final res = await _iExpenseRepository.getAllExpenses();
  //   if (res is ResultSuccess<List<ExpenseModel>>) {
  //     expenseList = res.value;
  //   }
  //   _expenseListSubject.sink.add(expenseList);
  // }

  // Future<void> saveExpense(ExpenseModel expense) async {
  //   final res = await _iExpenseRepository.saveExpense(expense);
  //   if (res is ResultSuccess<bool> && res.value) {
  //     List<ExpenseModel> expenseList = _expenseListSubject.value.toList();
  //     expenseList.add(expense);
  //     _expenseListSubject.sink.add(expenseList);
  //   }
  // }

  @override
  void dispose() {
    // _expenseListSubject.close();
    _transactionListSubject.close();
    _categoryListSubject.close();
    _subcategoryListSubject.close();
    _productListSubject.close();
  }
}

