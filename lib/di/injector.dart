

import 'package:gastos_app/data/converter/category_converter.dart';
import 'package:gastos_app/data/converter/expense_converter.dart';
import 'package:gastos_app/data/converter/list_item_converter.dart';
import 'package:gastos_app/data/converter/list_template_converter.dart';
import 'package:gastos_app/data/converter/product_converter.dart';
import 'package:gastos_app/data/converter/shopping_list_converter.dart';
import 'package:gastos_app/data/converter/subcategory_converter.dart';
import 'package:gastos_app/data/converter/transaction_converter.dart';
import 'package:gastos_app/data/converter/user_converter.dart';
import 'package:gastos_app/data/dao/category_dao.dart';
import 'package:gastos_app/data/dao/common_dao.dart';
import 'package:gastos_app/data/dao/expense_dao.dart';
import 'package:gastos_app/data/dao/list_item_dao.dart';
import 'package:gastos_app/data/dao/list_template_dao.dart';
import 'package:gastos_app/data/dao/measurement_unit_dao.dart';
import 'package:gastos_app/data/dao/product_dao.dart';
import 'package:gastos_app/data/dao/shopping_list_dao.dart';
import 'package:gastos_app/data/dao/subcategory_dao.dart';
import 'package:gastos_app/data/dao/transaction_dao.dart';
import 'package:gastos_app/data/dao/user_dao.dart';
import 'package:gastos_app/data/repository/category_repository.dart';
import 'package:gastos_app/data/repository/expense_repository.dart';
import 'package:gastos_app/data/repository/list_item_repository.dart';
import 'package:gastos_app/data/repository/list_template_repository.dart';
import 'package:gastos_app/data/repository/measurement_unit_repository.dart';
import 'package:gastos_app/data/repository/product_repository.dart';
import 'package:gastos_app/data/repository/shopping_list_repository.dart';
import 'package:gastos_app/data/repository/subcategory_repository.dart';
import 'package:gastos_app/data/repository/transaction_repository.dart';
import 'package:gastos_app/data/repository/user_repository.dart';
import 'package:gastos_app/data/shared_preferences/shared_preferences_managment.dart';
import 'package:gastos_app/domain/category/i_category_converter.dart';
import 'package:gastos_app/domain/category/i_category_dao.dart';
import 'package:gastos_app/domain/category/i_category_repository.dart';
import 'package:gastos_app/domain/common/i_common_dao.dart';
import 'package:gastos_app/domain/common/i_common_repository.dart';
import 'package:gastos_app/domain/expense/i_expense_dao.dart';
import 'package:gastos_app/domain/expense/i_expense_repository.dart';
import 'package:gastos_app/domain/list_item/i_list_item_converter.dart';
import 'package:gastos_app/domain/list_item/i_list_item_dao.dart';
import 'package:gastos_app/domain/list_item/i_list_item_repository.dart';
import 'package:gastos_app/domain/list_template/i_list_template_converter.dart';
import 'package:gastos_app/domain/list_template/i_list_template_dao.dart';
import 'package:gastos_app/domain/list_template/i_list_template_repository.dart';
import 'package:gastos_app/domain/measurement_unit_model/i_measurement_unit_dao.dart';
import 'package:gastos_app/domain/measurement_unit_model/i_measurement_unit_repository.dart';
import 'package:gastos_app/domain/product/i_product_converter.dart';
import 'package:gastos_app/domain/product/i_product_dao.dart';
import 'package:gastos_app/domain/product/i_product_repository.dart';
import 'package:gastos_app/domain/shopping_list/i_shopping_list_converter.dart';
import 'package:gastos_app/domain/shopping_list/i_shopping_list_dao.dart';
import 'package:gastos_app/domain/shopping_list/i_shopping_list_repository.dart';
import 'package:gastos_app/domain/subcategory/i_subcategory_converter.dart';
import 'package:gastos_app/domain/subcategory/i_subcategory_dao.dart';
import 'package:gastos_app/domain/subcategory/i_subcategory_repository.dart';
import 'package:gastos_app/domain/transaction/i_transaction_converter.dart';
import 'package:gastos_app/domain/transaction/i_transaction_dao.dart';
import 'package:gastos_app/domain/transaction/i_transaction_repository.dart';
import 'package:gastos_app/domain/user/i_user_converter.dart';
import 'package:gastos_app/domain/user/i_user_dao.dart';
import 'package:gastos_app/domain/user/i_user_repository.dart';
import 'package:gastos_app/ui/create_expense/create_expense_bloc.dart';
import 'package:gastos_app/ui/home/home_bloc.dart';
import 'package:gastos_app/ui/splash/splash_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:gastos_app/data/dao/2fa_dao.dart';
import 'package:gastos_app/domain/2fa/i_2fa_dao.dart';

import '../app_bloc.dart';
import '../base/bloc_base.dart';
import '../data/converter/2fa_converter.dart';
import '../data/local/app_database.dart';
import '../data/repository/2fa_repository.dart';
import '../domain/2fa/i_2fa_converter.dart';
import '../domain/2fa/i_2fa_repository.dart';
import '../utils/logger.dart';

///Part dependency injector engine and Part service locator.
///The main purpose of [Injector] is to provide bloCs instances and initialize the app components depending the current scope.
///To reuse a bloc instance in the widget's tree feel free to use the [BlocProvider] mechanism.
class Injector {
  ///Singleton instance
  static late Injector instance;

  static bool _initialized = false;

  KiwiContainer container = KiwiContainer();


  ///Is the app in debug mode?
  bool isInDebugMode() {
    var debugMode = false;
    assert(debugMode = true);
    return debugMode;
  }

  ///returns a new bloc instance
  T getNewBloc<T extends BaseBloC>() => container.resolve();

  T getDependency<T>() => container.resolve();

  Logger get logger => container.resolve();

  static init() {
    if(!_initialized) {
      instance = Injector._init();
      _initialized = true;
    }
  }

  Injector._init() {
    _initialize();
  }

  _initialize() {
    _registerCommon();
    _registerMappers();
    _registerDaoLayer();
    _registerRepositoryLayer();
    _registerBloCs();
  }

  _registerMappers() {
    container.registerSingleton<I2faConverter>((c) => TwoFaConverter());
    container.registerSingleton((c) => UserConverter());
    container.registerSingleton((c) => ExpenseConverter());
    container.registerSingleton<ICategoryConverter>((c) => CategoryConverter());
    container.registerSingleton<ISubcategoryConverter>((c) => SubcategoryConverter());
    container.registerSingleton<IListItemConverter>((c) => ListItemConverter());
    container.registerSingleton<IListTemplateConverter>((c) => ListTemplateConverter());
    container.registerSingleton<IProductConverter>((c) => ProductConverter());
    container.registerSingleton<ITransactionConverter>((c) => TransactionConverter());
    container.registerSingleton<IShoppingListConverter>((c) => ShoppingListConverter());
  }

  _registerDaoLayer() {
    container.registerSingleton((c) => AppDatabase.instance);
    container.registerSingleton<ICommonDao>((c) => CommonDao(
        c.resolve()));
    container.registerSingleton<I2faDao>((c) => TwoFaDao(
        c.resolve(), c.resolve()));
    container.registerSingleton<IUserDao>((c) => UserDao(
        c.resolve(), c.resolve()));
    container.registerSingleton<IExpenseDao>((c) => ExpenseDao(
        c.resolve(), c.resolve()));
    container.registerSingleton<ICategoryDao>((c) => CategoryDao(
        c.resolve()));
    container.registerSingleton<ISubcategoryDao>((c) => SubcategoryDao(
        c.resolve()));
    container.registerSingleton<IListItemDao>((c) => ListItemDao(
        c.resolve()));
    container.registerSingleton<IListTemplateDao>((c) => ListTemplateDao(
        c.resolve()));
    container.registerSingleton<IMeasurementUnitDao>((c) => MeasurementUnitDao(
        c.resolve()));
    container.registerSingleton<IProductDao>((c) => ProductDao(
        c.resolve()));
    container.registerSingleton<ITransactionDao>((c) => TransactionDao(
        c.resolve()));
    container.registerSingleton<IShoppingListDao>((c) => ShoppingListDao(
        c.resolve()));

  }

  _registerRepositoryLayer() {
    // container.registerSingleton<ICommonRepository>((c) => CommonRepository(
    //     c.resolve()));
    container.registerSingleton<I2faRepository>((c) => TwoFaRepository(
        c.resolve()));
    container.registerSingleton<IUserRepository>((c) => UserRepository(
        c.resolve(), c.resolve(), c.resolve(),));
    container.registerSingleton<IExpenseRepository>((c) => ExpenseRepository(
      c.resolve(), c.resolve(), c.resolve()));
    container.registerSingleton<ICategoryRepository>((c) => CategoryRepository());
    container.registerSingleton<ISubcategoryRepository>((c) => SubcategoryRepository());
    container.registerSingleton<IListItemRepository>((c) => ListItemRepository());
    container.registerSingleton<IListTemplateRepository>((c) => ListTemplateRepository());
    container.registerSingleton<IMeasurementUnitRepository>((c) => MeasurementUnitRepository());
    container.registerSingleton<IProductRepository>((c) => ProductRepository());
    container.registerSingleton<ITransactionRepository>((c) => TransactionRepository());
    container.registerSingleton<IShoppingListRepository>((c) => ShoppingListRepository());
  }

  _registerBloCs() {
    container.registerFactory((c) => BaseAppBloC());
    container.registerFactory((c) => HomeBloC(c.resolve()));
    container.registerFactory((c) => SplashBloc(
        c.resolve(), c.resolve()));
    container.registerFactory((c) => CreateExpenseBloc());
  }

  _registerCommon() {
    container.registerSingleton<Logger>((c) => LoggerImpl());
    container.registerSingleton((c) => SharedPreferencesManager(),);
  }

  ///returns the current instance of the logger
  Logger getLogger() => container.resolve();

  ///returns a new bloc instance
  // T getNewBloc<T extends BaseBloC>() => container.resolve();
  //
  // NetworkHandler get networkHandler => container.resolve();
  //
  SharedPreferencesManager get sharedP => container.resolve();
  //
  // T getDependency<T>() => container.resolve();
}
