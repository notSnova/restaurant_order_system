import 'package:flutter/material.dart';
import 'package:restaurant_order_system/pages/admin/customer_order_page.dart';
import 'package:restaurant_order_system/pages/admin/generate_qr_page.dart';
import 'package:restaurant_order_system/pages/admin/payment_page.dart';
import 'package:restaurant_order_system/widgets/tab_bar.dart';

class AdminPage extends StatefulWidget {
  final String adminId;

  const AdminPage({super.key, required this.adminId});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
        bodyContent = GenerateQRPage(adminId: widget.adminId);
        break;
      case 1:
        bodyContent = CustomerOrderPage();
        break;
      case 2:
        bodyContent = PaymentPage(searchController: searchController);
      default:
        bodyContent = const Center(
          child: Text('Page Content', style: TextStyle(color: Colors.black)),
        );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                adminId: widget.adminId,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
