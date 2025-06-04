import 'package:flutter/material.dart';
import 'package:restaurant_order_system/widgets/order_card.dart';
import 'package:restaurant_order_system/widgets/orders_page_history.dart';
import '../widgets/app_bar.dart';
import '../widgets/category_selector.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Page title
        CustomAppBar(showSearch: false, pageTitle: 'Order Status'),
        const SizedBox(height: 16),

        // Category selector
        CategorySelector(
          categories: ['All', 'Preparing', 'Completed', 'Cancelled', 'History'],
          onCategorySelected: (label) {
            setState(() {
              selectedCategory = label;
            });
          },
        ),
        const SizedBox(height: 25),

        // Order content based on selected category
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              if (selectedCategory == 'History') ...[
                const OrderHistoryCard(),
              ] else ...[
                const OrderCard(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
