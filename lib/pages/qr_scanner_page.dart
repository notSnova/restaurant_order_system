import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'main_page.dart';
import 'admin/admin_page.dart';

import 'dart:developer';

class QrScannerPage extends StatefulWidget {
  final bool isDevMode; // add this flag to constructor

  const QrScannerPage({super.key, this.isDevMode = false});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool _isScanned = false;
  late MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();

    if (widget.isDevMode) {
      log("[DEV MODE] Bypassing QR scan.");

      Future.delayed(const Duration(milliseconds: 500), () {
        // customer bypass
        // Navigator.pushReplacement(
        //   // ignore: use_build_context_synchronously
        //   context,
        //   MaterialPageRoute(builder: (_) => const MainPage(tableNumber: "1")),
        // );

        // admin bypass
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (_) => const AdminPage(adminId: "dev")),
        );
      });
    }
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_isScanned) return;

    final String? code = capture.barcodes.first.rawValue;

    // if data is table number, navigate to customer page
    if (code != null && code.startsWith("table_")) {
      setState(() => _isScanned = true);

      final tableNumber = code.replaceFirst("table_", "");
      _controller.stop();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainPage(tableNumber: tableNumber)),
      );

      // else to admin page
    } else if (code != null && code.startsWith("admin_")) {
      setState(() => _isScanned = true);

      final adminId = code.replaceFirst("admin_", "");
      _controller.stop();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminPage(adminId: adminId)),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid QR Code')));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if dev mode, optionally show a message while waiting
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFBF9B6F),
        centerTitle: true,
        title: const Text(
          'Scan Table QR',
          style: TextStyle(
            fontFamily: 'Istok Web',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body:
          widget.isDevMode
              ? const SizedBox()
              : MobileScanner(
                controller: _controller,
                onDetect: _handleBarcode,
              ),
    );
  }
}
