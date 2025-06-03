import 'package:flutter/material.dart';
import 'package:restaurant_order_system/widgets/order_card.dart';
import '../widgets/app_bar.dart';
import '../widgets/category_selector.dart';

import 'dart:developer';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // page title
        CustomAppBar(showSearch: false, pageTitle: 'Order Status'),
        const SizedBox(height: 16),

        // category selector
        CategorySelector(
          categories: ['All', 'Preparing', 'Completed', 'Cancelled', 'History'],
          onCategorySelected: (label) {
            log('Selected: $label'); // access the label
          },
        ),
        const SizedBox(height: 25),

        // order card
        SingleChildScrollView(
          child: Column(children: [Center(child: OrderCard())]),
        ),
      ],
    );
  }
}
