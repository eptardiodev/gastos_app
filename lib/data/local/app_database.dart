
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
        name TEXT UNIQUE,
        symbol TEXT UNIQUE
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

// Get subcategory IDs
    var panaderiaId = (await db.query('subcategories',
        where: 'name = ?', whereArgs: ['Panadería'])).first['id'] as int;
    var carnesId = (await db.query('subcategories',
        where: 'name = ?', whereArgs: ['Carnes'])).first['id'] as int;
    var combustibleId = (await db.query('subcategories',
        where: 'name = ?', whereArgs: ['Combustible'])).first['id'] as int;

    // Get unit IDs
    var unidadId = (await db.query('measurement_units',
        where: 'name = ?', whereArgs: ['Unidad'])).first['id'] as int;
    var kgId = (await db.query('measurement_units',
        where: 'name = ?', whereArgs: ['Kilogramo'])).first['id'] as int;
    var litroId = (await db.query('measurement_units',
        where: 'name = ?', whereArgs: ['Litro'])).first['id'] as int;
    var paqueteId = (await db.query('measurement_units',
        where: 'name = ?', whereArgs: ['Paquete'])).first['id'] as int;

    // Insert products for Panadería subcategory
    await db.insert('products', {
      'subcategory_id': panaderiaId,
      'name': 'Pan blanco',
      'description': 'Pan de molde blanco',
      'common_unit': 'unidad'
    });
    await db.insert('products', {
      'subcategory_id': panaderiaId,
      'name': 'Baguette',
      'description': 'Pan francés',
      'common_unit': 'unidad'
    });
    await db.insert('products', {
      'subcategory_id': panaderiaId,
      'name': 'Croissant',
      'description': 'Cruasán de mantequilla',
      'common_unit': 'unidad'
    });

    // Insert products for Carnes subcategory
    await db.insert('products', {
      'subcategory_id': carnesId,
      'name': 'Pechuga de pollo',
      'description': 'Pechuga de pollo fresca',
      'common_unit': 'kg'
    });
    await db.insert('products', {
      'subcategory_id': carnesId,
      'name': 'Carne molida',
      'description': 'Carne de res molida',
      'common_unit': 'kg'
    });
    await db.insert('products', {
      'subcategory_id': carnesId,
      'name': 'Salchichas',
      'description': 'Paquete de salchichas',
      'common_unit': 'paquete'
    });

    // Insert products for Combustible subcategory
    await db.insert('products', {
      'subcategory_id': combustibleId,
      'name': 'Gasolina 95',
      'description': 'Gasolina sin plomo 95 octanos',
      'common_unit': 'litro'
    });
    await db.insert('products', {
      'subcategory_id': combustibleId,
      'name': 'Diésel',
      'description': 'Combustible diésel',
      'common_unit': 'litro'
    });

    final p1 = (await db.query('products', where: 'name = ?', whereArgs: ['Pan blanco'])).first['id'];

    // Insert some sample transactions
    await db.insert('transactions', {
      'user_id': '12',
      'product_id': p1,
      'amount': 2.50,
      'quantity': 1,
      'unit_id': unidadId,
      'place': 'Supermercado Central',
      'date': DateTime.now().toIso8601String(),
      'notes': 'Compra semanal'
    });

    await db.insert('transactions', {
      'user_id': '12',
      'product_id': (await db.query('products', where: 'name = ?', whereArgs: ['Pechuga de pollo'])).first['id'],
      'amount': 8.75,
      'quantity': 0.5,
      'unit_id': kgId,
      'place': 'Carnicería Don José',
      'date': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
      'notes': 'Para la cena'
    });

    await db.insert('transactions', {
      'user_id': '12',
      'product_id': (await db.query('products', where: 'name = ?', whereArgs: ['Gasolina 95'])).first['id'],
      'amount': 45.30,
      'quantity': 10,
      'unit_id': litroId,
      'place': 'Estación de servicio Shell',
      'date': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
      'notes': 'Llenado de tanque'
    });

    // Create a sample shopping list
    await db.insert('shopping_lists', {
      'user_id': '12',
      'name': 'Lista semanal',
      'created_at': DateTime.now().toIso8601String(),
      'last_used': DateTime.now().toIso8601String()
    });

    var listaId = (await db.query('shopping_lists')).first['id'] as int;

    // Add items to the shopping list
    await db.insert('list_items', {
      'list_id': listaId,
      'product_id': (await db.query('products', where: 'name = ?', whereArgs: ['Pan blanco'])).first['id'],
      'quantity': 2,
      'unit_id': unidadId,
      'added_at': DateTime.now().toIso8601String()
    });

    await db.insert('list_items', {
      'list_id': listaId,
      'product_id': (await db.query('products', where: 'name = ?', whereArgs: ['Carne molida'])).first['id'],
      'quantity': 1,
      'unit_id': kgId,
      'added_at': DateTime.now().toIso8601String()
    });

    await db.insert('list_items', {
      'list_id': listaId,
      'product_id': (await db.query('products', where: 'name = ?', whereArgs: ['Salchichas'])).first['id'],
      'quantity': 1,
      'unit_id': paqueteId,
      'added_at': DateTime.now().toIso8601String()
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
