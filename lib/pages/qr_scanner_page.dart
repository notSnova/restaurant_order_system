import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'main_page.dart';
import 'admin/admin_page.dart';
import 'welcome_page.dart';

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

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final TextEditingController codeController = TextEditingController();
          String? errorText;

          return StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.white,
                title: const Text(
                  'Admin Security Code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Istok Web',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                content: TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  style: const TextStyle(
                    fontFamily: 'Istok Web',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter 4-digit code',
                    hintStyle: const TextStyle(
                      fontFamily: 'Istok Web',
                      color: Colors.black,
                    ),
                    counterText: '',
                    errorText: errorText,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFBF9B6F),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  onChanged: (value) {
                    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
                    if (value != digitsOnly) {
                      codeController.text = digitsOnly;
                      codeController.selection = TextSelection.fromPosition(
                        TextPosition(offset: digitsOnly.length),
                      );
                    }

                    if (errorText != null) {
                      setStateDialog(() => errorText = null);
                    }
                  },
                ),
                actionsPadding: const EdgeInsets.only(right: 16, bottom: 10),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _isScanned = false);
                      _controller.start();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      textStyle: const TextStyle(
                        fontFamily: 'Istok Web',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (codeController.text == '0123') {
                        Navigator.pop(context);

                        // login message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Admin $adminId logged in.',
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

                        // redirect to admin page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AdminPage(adminId: adminId),
                          ),
                        );
                      } else {
                        setStateDialog(() {
                          errorText = 'Incorrect code';
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBF9B6F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Istok Web',
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Confirm'),
                  ),
                ],
              );
            },
          );
        },
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WelcomePage()),
            );
          },
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
