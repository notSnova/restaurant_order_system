import 'package:flutter/material.dart';
import 'package:restaurant_order_system/pages/welcome_page.dart';
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

  void _showQuantityModal(BuildContext context, Map<String, dynamic> item) {
    int quantity = 1;
    double price = double.tryParse(item['price'].toString()) ?? 0.0;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            double menuPrice = quantity * price;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item['label'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Price: RM ${menuPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() => quantity--);
                          }
                        },
                      ),
                      Text('$quantity', style: const TextStyle(fontSize: 20)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() => quantity++);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      // insert into database
                      await dbHelper.insertOrder(
                        tableNumber: widget.tableNumber,
                        itemLabel: item['label'],
                        quantity: quantity,
                        menuPrice: menuPrice,
                      );

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Your order has been added!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Color(0xFFBF9B6F),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBF9B6F),
                    ),
                    child: const Text(
                      'Add Order',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
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
          onBack: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => WelcomePage()),
            );
          },
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
            : MenuSelection(
              items: menuItems,
              onItemTap: (item) {
                FocusManager.instance.primaryFocus?.unfocus();
                _showQuantityModal(context, item);
              },
            ),
      ],
    );
  }
}
