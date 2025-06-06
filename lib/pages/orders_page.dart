import 'package:flutter/material.dart';
import 'package:restaurant_order_system/database/db_helper.dart';
import 'package:restaurant_order_system/widgets/order_card.dart';
import '../widgets/app_bar.dart';
import '../widgets/category_selector.dart';

import 'dart:developer';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String selectedCategory = "All";
  List<Map<String, dynamic>> orderList = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders({String category = 'Preparing'}) async {
    List<Map<String, dynamic>> orders = [];

    if (category == 'History') {
      final all = await DBHelper().getOrders();
      orders =
          all
              .where(
                (order) =>
                    order['status'] == 'Completed' ||
                    order['status'] == 'Cancelled',
              )
              .toList();
    } else {
      orders = await DBHelper().getOrdersByStatus(category);
    }

    setState(() {
      selectedCategory = category;
      orderList = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        CustomAppBar(showSearch: false, pageTitle: 'Order Status'),
        const SizedBox(height: 16),

        CategorySelector(
          categories: ['Preparing', 'Completed', 'Cancelled', 'History'],
          onCategorySelected: (label) {
            log('Selected: $label');
            _loadOrders(category: label);
          },
        ),
        const SizedBox(height: 25),

        orderList.isEmpty
            ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 64),
                child: Text(
                  'No orders found.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
            : Column(
              children:
                  orderList
                      .map(
                        (order) => OrderCard(
                          orderData: order,
                          onCancel: () async {
                            await DBHelper().cancelOrder(order['id']);
                            _loadOrders(
                              category: selectedCategory,
                            ); // refresh with current category
                          },
                        ),
                      )
                      .toList(),
            ),
      ],
    );
  }
}
