import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'restaurant.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE menu_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          imageUrl TEXT NOT NULL,
          label TEXT NOT NULL,
          price REAL NOT NULL,
          category TEXT NOT NULL
        )
      ''');

        await db.execute('''
        CREATE TABLE orders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          table_number TEXT NOT NULL,
          item_label TEXT NOT NULL,
          quantity INTEGER NOT NULL,
          menu_price REAL NOT NULL,
          status TEXT NOT NULL,
          timestamp TEXT NOT NULL
        ) 
      ''');
      },
    );
  }

  // menu page sql logic
  Future<void> insertMenuItem(
    String imageUrl,
    String label,
    double price,
    String category,
  ) async {
    final db = await database;
    await db.insert('menu_items', {
      'imageUrl': imageUrl,
      'label': label,
      'price': price,
      'category': category,
    });
  }

  Future<List<Map<String, dynamic>>> getMenuItems() async {
    final db = await database;
    return await db.query('menu_items');
  }

  Future<List<Map<String, dynamic>>> getMenuItemsByCategory(
    String category,
  ) async {
    final db = await database;
    return await db.query(
      'menu_items',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  // order page sql logic
  Future<void> insertOrder({
    required String tableNumber,
    required String itemLabel,
    required int quantity,
    required double menuPrice,
    String status = 'pending',
  }) async {
    final db = await database;

    await db.insert('orders', {
      'table_number': tableNumber,
      'item_label': itemLabel,
      'quantity': quantity,
      'menu_price': menuPrice,
      'timestamp': DateTime.now().toIso8601String(),
      'status': status,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    log('Order added: [$status] $itemLabel x$quantity @ Table $tableNumber');
  }

  // delete database
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'restaurant.db');

    // close existing connection if open
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    await deleteDatabase(path);
    log('restaurant.db has been deleted.');
  }
}
