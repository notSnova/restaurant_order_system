import 'package:flutter/material.dart';
import 'package:restaurant_order_system/pages/menu_page.dart';
import 'package:restaurant_order_system/pages/orders_page.dart';
import 'package:restaurant_order_system/widgets/tab_bar.dart';

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
        bodyContent = MenuPage(searchController: searchController);
        break;
      case 1:
        bodyContent = OrdersPage();
        break;
      case 2:
        bodyContent = const Center(
          child: Text(
            'Login Page Content',
            style: TextStyle(color: Colors.black),
          ),
        );
        break;
      default:
        bodyContent = const Center(
          child: Text('Page Content', style: TextStyle(color: Colors.black)),
        );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: bodyContent),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: TabBars(
                selectedIndex: _selectedIndex,
                onTap: _onTabSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
