import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:restaurant_order_system/database/db_helper.dart';
import 'package:restaurant_order_system/widgets/app_bar.dart';
import 'package:restaurant_order_system/widgets/category_selector.dart';
import 'package:restaurant_order_system/widgets/customer_order_card.dart';

class CustomerOrderPage extends StatefulWidget {
  const CustomerOrderPage({super.key});

  @override
  State<CustomerOrderPage> createState() => _CustomerOrderPageState();
}

class _CustomerOrderPageState extends State<CustomerOrderPage> {
  final List<String> categories = ['Preparing', 'Completed', 'Cancelled'];
  String selectedCategory = 'Preparing';
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrdersByStatus();
  }

  Future<void> _loadOrdersByStatus() async {
    final results = await DBHelper().getOrdersByStatus(selectedCategory);
    setState(() {
      orders = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(showSearch: false, pageTitle: 'Customer Orders'),
          const SizedBox(height: 16),
          CategorySelector(
            categories: categories,
            initialSelectedIndex: categories.indexOf(selectedCategory),
            onCategorySelected: (category) {
              log('Selected category: $category');
              setState(() {
                selectedCategory = category;
              });
              _loadOrdersByStatus();
            },
          ),
          const SizedBox(height: 15),
          Expanded(
            child:
                orders.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          SizedBox(height: 40),
                          Text(
                            'No orders found.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final orderData = orders[index];
                        final isLast = index == orders.length - 1;

                        return Padding(
                          padding: EdgeInsets.only(
                            top: 0,
                            bottom: isLast ? 130 : 0,
                          ),
                          child: CustomerOrderCard(
                            orderData: orderData,
                            onMarkCompleted: () async {
                              await DBHelper().completeOrder(orderData['id']);
                              _loadOrdersByStatus();
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
