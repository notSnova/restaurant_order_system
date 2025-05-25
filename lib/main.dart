import 'package:flutter/material.dart';
import 'package:restaurant_order_system/pages/home_page.dart';
import 'package:restaurant_order_system/widgets/tab_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFFD9D9D9),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final searchController = TextEditingController();

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    switch (_selectedIndex) {
      case 0:
        bodyContent = HomePage(searchController: searchController);
        break;
      case 1:
        bodyContent = Center(
          child: Text(
            'Orders Page Content',
            style: TextStyle(color: Colors.black),
          ),
        );
        break;
      case 2:
        bodyContent = Center(
          child: Text(
            'Login Page Content',
            style: TextStyle(color: Colors.black),
          ),
        );
        break;
      default:
        bodyContent = Center(
          child: Text('Page Content', style: TextStyle(color: Colors.black)),
        );
    }

    return Scaffold(
      body: bodyContent,
      bottomNavigationBar: TabBars(
        selectedIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
