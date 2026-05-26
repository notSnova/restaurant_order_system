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
          payment_status TEXT NOT NULL,
          payment_id TEXT NULL,
          timestamp TEXT NOT NULL,
          payment_timestamp TEXT
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
    String status = 'Preparing',
    String paymentStatus = 'Unpaid',
  }) async {
    final db = await database;

    await db.insert('orders', {
      'table_number': tableNumber,
      'item_label': itemLabel,
      'quantity': quantity,
      'menu_price': menuPrice,
      'timestamp': DateTime.now().toIso8601String(),
      'status': status,
      'payment_status': paymentStatus,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    log('Order added: [$status] $itemLabel x$quantity @ Table $tableNumber');
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;

    return await db.rawQuery('''
    SELECT 
      orders.id,
      orders.table_number,
      orders.item_label,
      orders.quantity,
      orders.menu_price,
      orders.status,
      orders.payment_status,
      orders.timestamp,
      menu_items.imageUrl
    FROM orders
    LEFT JOIN menu_items 
    ON orders.item_label = menu_items.label
    ORDER BY orders.timestamp DESC
  ''');
  }

  Future<List<Map<String, dynamic>>> getOrdersByTableAndStatus({
    required String tableNumber,
    required String status,
  }) async {
    final db = await database;

    return await db.rawQuery(
      '''
    SELECT 
      orders.id,
      orders.table_number,
      orders.item_label,
      orders.quantity,
      orders.menu_price,
      orders.status,
      orders.payment_status,
      orders.timestamp,
      menu_items.imageUrl
    FROM orders
    LEFT JOIN menu_items 
    ON orders.item_label = menu_items.label
    WHERE orders.table_number = ? AND orders.status = ? AND orders.payment_status = 'Unpaid'
    ORDER BY orders.timestamp DESC
  ''',
      [tableNumber, status],
    );
  }

  Future<List<Map<String, dynamic>>> getOrdersByStatus(String status) async {
    final db = await database;

    return await db.rawQuery(
      '''
    SELECT 
      orders.id,
      orders.table_number,
      orders.item_label,
      orders.quantity,
      orders.menu_price,
      orders.status,
      orders.timestamp,
      menu_items.imageUrl
    FROM orders
    LEFT JOIN menu_items 
    ON orders.item_label = menu_items.label
    WHERE orders.status = ?
    ORDER BY orders.timestamp ASC
  ''',
      [status],
    );
  }

  Future<void> cancelOrder(int orderId) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': 'Cancelled'},
      where: 'id = ?',
      whereArgs: [orderId],
    );
    log('Order $orderId cancelled');
  }

  Future<void> completeOrder(int orderId) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': 'Completed'},
      where: 'id = ?',
      whereArgs: [orderId],
    );
    log('Order $orderId completed');
  }

  Future<List<Map<String, dynamic>>> getOrdersByTableAndPaymentStatus({
    required String paymentStatus,
    String? tableNumber,
  }) async {
    final db = await database;

    String query = '''
    SELECT 
      orders.id,
      orders.table_number,
      orders.item_label,
      orders.quantity,
      orders.menu_price,
      orders.status,
      orders.payment_status,
      orders.payment_id,
      orders.timestamp,
      orders.payment_timestamp,
      menu_items.imageUrl
    FROM orders
    LEFT JOIN menu_items 
    ON orders.item_label = menu_items.label
    WHERE orders.status = 'Completed' AND orders.payment_status = ?
  ''';

    List<dynamic> args = [paymentStatus];

    if (tableNumber != null) {
      query += ' AND orders.table_number = ?';
      args.add(tableNumber);
    }

    query += ' ORDER BY orders.timestamp DESC';

    return await db.rawQuery(query, args);
  }

  Future<void> updateOrderPaymentStatus(
    int orderId,
    String paymentStatus, {
    String? paymentId,
  }) async {
    final db = await database;
    await db.update(
      'orders',
      {
        'payment_status': paymentStatus,
        if (paymentId != null) 'payment_id': paymentId,
        'payment_timestamp': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [orderId],
    );

    log(
      'Order $orderId marked as $paymentStatus with payment ID: ${paymentId ?? 'N/A'}',
    );
  }

  Future<void> updateOrderPaymentStatusCancelled(String tableNumber) async {
    final db = await database;
    await db.update(
      'orders',
      {'payment_status': 'Refunded'},
      where: 'table_number = ? AND status = ?',
      whereArgs: [tableNumber, 'Cancelled'],
    );

    log('Cancelled orders for table $tableNumber marked as Refunded.');
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
