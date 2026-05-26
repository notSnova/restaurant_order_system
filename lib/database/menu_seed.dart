import 'dart:developer';

import 'package:restaurant_order_system/database/db_helper.dart';
import 'package:restaurant_order_system/models/menu_item.dart';

Future<void> insertMenus() async {
  final dbHelper = DBHelper();

  for (final item in seedMenuItems) {
    await dbHelper.insertMenuItem(
      item.imageUrl,
      item.label,
      item.price,
      item.category,
    );
  }

  log("Menu items inserted.");
}
