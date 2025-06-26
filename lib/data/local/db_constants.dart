class DBConstants {
  static const String dbName = 'gastos_app_db';
  static const int dbVersion = 1;

  /// Common table schema
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

  /// Column names
  static const String idKey = 'id';
  static const String dataKey = 'data';
  static const String parentKey = 'parent_id';
  static const String date = 'date';

  /// Column types
  static const String textType = 'TEXT';
  static const String realType = 'REAL';
  static const String intType = 'INTEGER';

  /// Existing table names
  static const String authenticatedEntityTable = 'authenticated_entity_table';
  static const String profileTable = 'profile_table';
  static const String expensesTable = 'expenses_table';
  static const String categoriesTable = 'categories';
  static const String subcategoriesTable = 'subcategories';
  static const String measurementUnitsTable = 'measurement_units';
  static const String productsTable = 'products';
  static const String shoppingListsTable = 'shopping_lists';
  static const String listItemsTable = 'list_items';
  static const String transactionsTable = 'transactions';
  static const String usersTable = 'users';
  static const String groupsTable = 'groups';
  static const String groupMembersTable = 'group_members';
  static const String listUserSharesTable = 'list_user_shares';
  static const String listGroupSharesTable = 'list_group_shares';

  /// Keys for use in parent_key column
  static const String address = 'address';
}
