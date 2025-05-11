
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'db_constants.dart';
import 'dart:io';

class AppDatabase {
  AppDatabase._privateConstructor();

  static final AppDatabase instance = AppDatabase._privateConstructor();

  Database? _db;

  Future<Database> get db async {
    if (_db == null) await _initDb();
    return _db!;
  }

  _initDb() async {
    String documentsDirectory = Platform.isAndroid ? await getDatabasesPath() : '${(await getApplicationSupportDirectory()).path}/';
    String path = join(documentsDirectory, DBConstants.dbName);
    _db = await openDatabase(path,
        version: DBConstants.dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await _createTables(db);
    }
  }

  Future _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future _createTables(Database db) async {
    await _createTable(db, DBConstants.authenticatedEntityTable, DBConstants.tableCols);
    await _createTable(db, DBConstants.profileTable, DBConstants.tableCols);
    await _createTable(db, DBConstants.expensesTable, DBConstants.tableExpensesCols);

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        icon_name TEXT,
        color_hex TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE subcategories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE,
        UNIQUE(category_id, name)
      )
    ''');

    await db.execute('''
      CREATE TABLE measurement_units (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        symbol TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subcategory_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        common_unit TEXT,
        FOREIGN KEY (subcategory_id) REFERENCES subcategories (id) ON DELETE CASCADE,
        UNIQUE(subcategory_id, name)
      )
    ''');

    await db.execute('''
      CREATE TABLE shopping_lists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        last_used TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE list_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        list_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity REAL,
        unit_id INTEGER,
        is_checked INTEGER DEFAULT 0,
        added_at TEXT NOT NULL,
        FOREIGN KEY (list_id) REFERENCES shopping_lists (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
        FOREIGN KEY (unit_id) REFERENCES measurement_units (id) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        product_id INTEGER,
        amount REAL NOT NULL,
        quantity REAL,
        unit_id INTEGER,
        place TEXT,
        date TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE SET NULL,
        FOREIGN KEY (unit_id) REFERENCES measurement_units (id) ON DELETE SET NULL
      )
    ''');

    await _insertInitialData(db);

  }

  Future _insertInitialData(Database db) async {
    await db.insert('measurement_units', {
      'name': 'Unidad', 'symbol': 'u'
    });
    await db.insert('measurement_units', {
      'name': 'Kilogramo', 'symbol': 'kg'
    });
    await db.insert('measurement_units', {
      'name': 'Litro', 'symbol': 'l'
    });
    await db.insert('measurement_units', {
      'name': 'Paquete', 'symbol': 'pqt'
    });

    await db.insert('categories', {
      'name': 'Alimentos',
      'icon_name': 'shopping-cart',
      'color_hex': '#FF6B6B'
    });
    await db.insert('categories', {
      'name': 'Transporte',
      'icon_name': 'bus',
      'color_hex': '#4ECDC4'
    });
    await db.insert('categories', {
      'name': 'Misceláneo',
      'icon_name': 'box',
      'color_hex': '#8395A7'
    });

    var alimentosId = await db.query('categories',
        where: 'name = ?', whereArgs: ['Alimentos']);
    await db.insert('subcategories', {
      'category_id': alimentosId.first['id'],
      'name': 'Panadería'
    });
    await db.insert('subcategories', {
      'category_id': alimentosId.first['id'],
      'name': 'Carnes'
    });

    var transporteId = await db.query('categories',
        where: 'name = ?', whereArgs: ['Transporte']);
    await db.insert('subcategories', {
      'category_id': transporteId.first['id'],
      'name': 'Combustible'
    });
  }


  Future close() async {
    final db = await instance.db;
    db.close();
  }

  static Future<bool> _createTable(
      Database db, String tableName, Map<String, String> columns) async {
    if (columns.isEmpty) return false;

    try {
      var script = 'CREATE TABLE $tableName ( ';
      for (var key in columns.keys) {
        final val = columns[key];
        if (key == columns.keys.first) {
          script = '$script $key $val PRIMARY KEY';
        } else {
          script = '$script, $key $val';
        }
      }

      script = script + ')';

      await db.execute(script);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<int> deleteAll(String tableName) async {
    final res = await _db?.delete(tableName);
    return res!;
  }
}
