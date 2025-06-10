import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:restaurant_order_system/database/db_helper.dart';
import 'package:restaurant_order_system/widgets/app_bar.dart';
import 'package:restaurant_order_system/widgets/category_selector.dart';

class PaymentPage extends StatefulWidget {
  final TextEditingController searchController;
  const PaymentPage({super.key, required this.searchController});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final List<String> categories = ['Unpaid', 'Paid'];
  String selectedCategory = 'Unpaid';
  Map<String, List<Map<String, dynamic>>> groupedOrders = {};
  bool isLoading = true;

  // generate random payment id
  String _generateRandomPaymentId({int length = 8}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(
      length,
      (index) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      isLoading = true;
    });

    try {
      final orders = await DBHelper().getOrdersByTableAndPaymentStatus(
        paymentStatus: selectedCategory,
      );

      // group by payment_id if it's a paid order, else group by table_number
      Map<String, List<Map<String, dynamic>>> grouped = {};
      for (var order in orders) {
        String key;
        if (selectedCategory == 'Paid') {
          String paymentId = order['payment_id'] ?? 'UnknownPayment';
          key = paymentId;
        } else {
          key = order['table_number'].toString();
        }

        if (!grouped.containsKey(key)) {
          grouped[key] = [];
        }
        grouped[key]!.add(order);
      }

      setState(() {
        groupedOrders = grouped;
        isLoading = false;
      });
    } catch (e) {
      developer.log('Error loading orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  double _calculateTableTotal(List<Map<String, dynamic>> orders) {
    return orders.fold(0.0, (sum, order) {
      double price = (order['menu_price'] ?? 0.0).toDouble();
      return sum + price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(showSearch: false, pageTitle: 'Table Payment'),
          const SizedBox(height: 16),
          Center(
            child: CategorySelector(
              categories: categories,
              initialSelectedIndex: categories.indexOf(selectedCategory),
              onCategorySelected: (label) {
                developer.log('Selected: $label');
                setState(() {
                  selectedCategory = label;
                });
                _loadOrders(); // Reload data when category changes
              },
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : groupedOrders.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          SizedBox(height: 40),
                          Text(
                            'No table found.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        16.0,
                        130.0,
                      ),
                      itemCount: groupedOrders.keys.length,
                      itemBuilder: (context, index) {
                        String key = groupedOrders.keys.elementAt(index);
                        List<Map<String, dynamic>> orders = groupedOrders[key]!;

                        String tableNumber =
                            orders.first['table_number'].toString();
                        // String paymentId =
                        //     orders.first['payment_id'] ?? 'UnknownPayment';

                        double tableTotal = _calculateTableTotal(orders);

                        return GestureDetector(
                          onTap:
                              () => _showOrderDetailsBottomSheet(
                                tableNumber,
                                orders,
                                tableTotal,
                              ),
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Color(0xFFAEAEAE),
                                width: 1,
                              ),
                            ),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Left side - Table info
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Table $tableNumber',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Total: RM ${tableTotal.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Right side - Status
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        child: Text(
                                          selectedCategory,
                                          style: TextStyle(
                                            color:
                                                selectedCategory == 'Unpaid'
                                                    ? Colors.red.shade600
                                                    : Colors.green.shade600,
                                            fontFamily: 'Istok Web',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Future<void> _showOrderDetailsBottomSheet(
    String tableNumber,
    List<Map<String, dynamic>> orders,
    double tableTotal,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Table $tableNumber',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Text(
                    selectedCategory,
                    style: TextStyle(
                      color:
                          selectedCategory == 'Unpaid'
                              ? Colors.red.shade600
                              : Colors.green.shade600,
                      fontFamily: 'Istok Web',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Order Items List
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            // Menu Item Image
                            Container(
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade300,
                              ),
                              child:
                                  order['imageUrl'] != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          order['imageUrl'],
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Icon(
                                              Icons.fastfood,
                                              color: Colors.grey,
                                            );
                                          },
                                        ),
                                      )
                                      : const Icon(
                                        Icons.fastfood,
                                        color: Colors.grey,
                                      ),
                            ),
                            const SizedBox(width: 16),

                            // Item Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order['item_label'] ?? 'Unknown Item',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Quantity: ${order['quantity'] ?? 0}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Unit Price: RM ${((order['menu_price'] ?? 0.0).toDouble() / (order['quantity'] ?? 1)).toStringAsFixed(2)}', // Divide by quantity for unit price
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Total Price for this item (which is menu_price * quantity)
                            Text(
                              'RM ${((order['menu_price'] ?? 0.0).toDouble()).toStringAsFixed(2)}', // This should be the total for the item, which is already menu_price if menu_price represents total for quantity
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color:
                                    selectedCategory == 'Unpaid'
                                        ? Colors.red.shade600
                                        : Colors.green.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Total Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'RM ${tableTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            selectedCategory == 'Unpaid'
                                ? Colors.red.shade600
                                : Colors.green.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Action Button
                if (selectedCategory == 'Unpaid')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _markAsPaid(tableNumber, orders);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBF9B6F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Mark as Paid',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 30),
              ],
            ),
          ),
    );
  }

  Future<void> _markAsPaid(
    String tableNumber,
    List<Map<String, dynamic>> orders,
  ) async {
    try {
      // Update payment status for all orders in this table
      String paymentId = _generateRandomPaymentId();
      for (var order in orders) {
        // You'll need to add this method to your DatabaseHelper
        await DBHelper().updateOrderPaymentStatus(
          order['id'],
          'Paid',
          paymentId: paymentId,
        );

        await DBHelper().updateOrderPaymentStatusCancelled(
          order['table_number'],
        );
      }

      // Show success message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Table $tableNumber has marked as paid.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: const Color(0xFFBF9B6F),
          duration: const Duration(seconds: 2),
        ),
      );

      // Reload the orders
      _loadOrders();
    } catch (e) {
      developer.log('Error marking as paid: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating payment status'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
