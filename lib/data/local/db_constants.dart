class DBConstants {
  static const String dbName = 'gastos_app_db';
  static const int dbVersion = 1;

  ///Common table schema
  static final Map<String, String> tableCols = {
    DBConstants.idKey: DBConstants.textType,
    DBConstants.dataKey: DBConstants.textType,
    DBConstants.parentKey: DBConstants.textType,
  };

  static final Map<String, String> tableExpensesCols = {
    DBConstants.idKey: DBConstants.textType,
    DBConstants.date: DBConstants.textType,
    DBConstants.dataKey: DBConstants.textType,
  };

  ///columns names
  static const String idKey = 'id';
  static const String dataKey = 'data';
  static const String parentKey = 'parent_id';
  static const String date = 'date';

  ///columns types
  static const String textType = 'TEXT';
  static const String realType = 'REAL';
  static const String intType = 'INTEGER';

  ///table names
  static const String authenticatedEntityTable = 'authenticated_entity_table';
  static final String profileTable = 'profile_table';
  static final String expensesTable = 'expenses_table';
  static final String categoriesTable = 'categories';
  static final String subcategoriesTable = 'subcategories';
  static final String measurementUnitsTable = 'measurement_units';
  static final String productsTable = 'products';
  static final String shoppingListsTable = 'shopping_lists';
  static final String listItemsTable = 'list_items';
  static final String transactionsTable = 'transactions';

  ///keys for use in parent_key column
  static final String address = 'address';

}
