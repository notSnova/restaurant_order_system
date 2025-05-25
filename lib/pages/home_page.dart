import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';

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
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Home Page Content',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
