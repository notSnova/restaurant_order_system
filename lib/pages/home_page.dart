import 'package:flutter/material.dart';
import 'package:restaurant_order_system/models/menu_item.dart';
import '../widgets/app_bar.dart';
import '../widgets/category_selector.dart';
import '../widgets/menu_selection.dart';

class HomePage extends StatelessWidget {
  final TextEditingController searchController;

  const HomePage({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        CustomAppBar(
          showSearch: true,
          searchController: searchController,
          onSearchChanged: (value) {},
        ),

        // Page Title
        // CustomAppBar(
        //   showSearch: false,
        //   pageTitle: 'Menu List',
        // ),
        const SizedBox(height: 16),

        // category selector
        CategorySelector(),

        // menu selection card
        MenuSelection(items: menuItems),
      ],
    );
  }
}
