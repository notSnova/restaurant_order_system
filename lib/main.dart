import 'package:flutter/material.dart';
import 'package:restaurant_order_system/database/db_helper.dart';
import 'package:restaurant_order_system/pages/welcome_page.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DBHelper();
  await dbHelper.deleteDatabaseFile();
  await dbHelper.database;
  insertMenus();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFFD9D9D9),
      ),
      home: const WelcomePage(),
    );
  }
}

void insertMenus() async {
  final dbHelper = DBHelper();

  await dbHelper.insertMenuItem(
    "assets/menus/nasi_lemak.png",
    "Nasi Lemak",
    3.00,
    "Food",
  );
  await dbHelper.insertMenuItem(
    "assets/menus/bihun_goreng.png",
    "Bihun Goreng",
    4.50,
    "Food",
  );
  await dbHelper.insertMenuItem(
    "assets/menus/kway_teow_goreng.png",
    "Kway Teow Goreng",
    5.00,
    "Food",
  );
  await dbHelper.insertMenuItem(
    "assets/menus/maggi_goreng.png",
    "Maggi Goreng",
    4.50,
    "Food",
  );
  await dbHelper.insertMenuItem(
    "assets/menus/kopi_ais.png",
    "Kopi Ais",
    2.00,
    "Drinks",
  );

  log("Menu items inserted.");
}
