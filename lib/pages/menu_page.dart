import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/category_selector.dart';
import '../widgets/menu_selection.dart';
import '../database/db_helper.dart';

import 'dart:developer';

class MenuPage extends StatefulWidget {
  final String tableNumber;
  final TextEditingController searchController;

  const MenuPage({
    super.key,
    required this.searchController,
    required this.tableNumber,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>> allMenuItems = []; // full list for category
  List<Map<String, dynamic>> menuItems = []; // filtered by search
  final dbHelper = DBHelper();

  // default to first category
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Food',
    'Drinks',
    'Soups',
    'Desserts',
  ];

  @override
  void initState() {
    super.initState();
    _loadMenuItemsByCategory(selectedCategory);
  }

  Future<void> _loadMenuItemsByCategory(String category) async {
    List<Map<String, dynamic>> items;

    if (category == 'All') {
      // fetch all items
      items = await dbHelper.getMenuItems();
    } else {
      // or else by category
      items = await dbHelper.getMenuItemsByCategory(category);
    }

    setState(() {
      selectedCategory = category;
      allMenuItems = items;
    });

    // apply filter
    _filterMenuItems(widget.searchController.text);
  }

  void _filterMenuItems(String query) {
    final trimmedQuery = query.trim().toLowerCase();

    setState(() {
      if (trimmedQuery.isEmpty) {
        menuItems = allMenuItems;
      } else {
        menuItems =
            allMenuItems.where((item) {
              final label = item['label'].toString().toLowerCase();
              return label.contains(trimmedQuery);
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // search bar
        CustomAppBar(
          showSearch: true,
          searchController: widget.searchController,
          onSearchChanged: _filterMenuItems,
        ),
        const SizedBox(height: 16),

        // table number display
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Table Number: ${widget.tableNumber}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // category selector
        CategorySelector(
          categories: categories,
          initialSelectedIndex: categories.indexOf(selectedCategory),
          onCategorySelected: (label) {
            log('Selected: $label');
            _loadMenuItemsByCategory(label); // loads and filters again
          },
        ),

        // menu selection display filtered items
        menuItems.isEmpty
            ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 64),
              child: Center(
                child: Text(
                  'No menu found.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            )
            : MenuSelection(items: menuItems),
      ],
    );
  }
}
