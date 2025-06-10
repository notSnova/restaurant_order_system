import 'package:flutter/material.dart';
import 'package:restaurant_order_system/database/db_helper.dart';
import 'package:restaurant_order_system/widgets/order_card.dart';
import '../widgets/app_bar.dart';
import '../widgets/category_selector.dart';

import 'dart:developer';

class OrdersPage extends StatefulWidget {
  final String tableNumber;
  const OrdersPage({super.key, required this.tableNumber});

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
                    (order['status'] == 'Completed' ||
                        order['status'] == 'Cancelled') &&
                    order['table_number'] == widget.tableNumber &&
                    order['payment_status'] == 'Unpaid',
              )
              .toList();
    } else if (category == 'Cancelled') {
      final all = await DBHelper().getOrders();
      orders =
          all
              .where(
                (order) =>
                    (order['status'] == 'Cancelled') &&
                    order['table_number'] == widget.tableNumber &&
                    order['payment_status'] == 'Unpaid',
              )
              .toList();
    } else {
      orders = await DBHelper().getOrdersByTableAndStatus(
        tableNumber: widget.tableNumber,
        status: category,
      );
    }

    setState(() {
      selectedCategory = category;
      orderList = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 15),
          Expanded(
            child:
                orderList.isEmpty
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
                      itemCount: orderList.length,
                      itemBuilder: (context, index) {
                        final order = orderList[index];
                        final isLast = index == orderList.length - 1;

                        return Padding(
                          padding: EdgeInsets.only(
                            top: 0,
                            bottom: isLast ? 130 : 0,
                          ),
                          child: OrderCard(
                            orderData: order,
                            onCancel: () async {
                              await DBHelper().cancelOrder(order['id']);
                              _loadOrders(category: selectedCategory);
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
