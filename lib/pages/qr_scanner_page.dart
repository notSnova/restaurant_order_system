import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'main_page.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

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
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_isScanned) return;

    final String? code = capture.barcodes.first.rawValue;

    if (code != null && code.startsWith("table_")) {
      setState(() => _isScanned = true);

      final tableNumber = code.replaceFirst("table_", "");
      _controller.stop(); // stop the scanner before navigating

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainPage(tableNumber: tableNumber)),
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
      body: MobileScanner(controller: _controller, onDetect: _handleBarcode),
    );
  }
}
