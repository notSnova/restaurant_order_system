import 'package:flutter/material.dart';
import 'package:restaurant_order_system/database/db_helper.dart';
import 'package:restaurant_order_system/database/menu_seed.dart';
import 'package:restaurant_order_system/pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DBHelper();
  await dbHelper.database;
  await insertMenus();
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
