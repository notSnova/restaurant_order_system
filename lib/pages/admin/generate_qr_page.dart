import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:restaurant_order_system/pages/welcome_page.dart';
import 'package:restaurant_order_system/widgets/app_bar.dart';

class GenerateQRPage extends StatefulWidget {
  final String adminId;

  const GenerateQRPage({super.key, required this.adminId});

  @override
  State<GenerateQRPage> createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends State<GenerateQRPage> {
  final TextEditingController _tableController = TextEditingController();
  String? _errorText; // error state

  void _generateQrCode() {
    final tableNumberText = _tableController.text.trim();

    setState(() {
      _errorText = null; // clear error before validating
    });

    // check if empty
    if (tableNumberText.isEmpty) {
      setState(() {
        _errorText = 'Please enter a table number';
      });
      return;
    }

    // if not empty parse as int
    final tableNumber = int.tryParse(tableNumberText);

    // if table number is below than 1
    if (tableNumber == null || tableNumber <= 0) {
      setState(() {
        _errorText = 'Must be a number greater than 0';
      });
      return;
    }

    final generatedQrData = 'table_$tableNumber';

    // show modal bottom sheet with QR code
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _buildQrModal(generatedQrData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        CustomAppBar(
          showSearch: false,
          pageTitle: 'Table QR Code',
          onBack: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => WelcomePage()),
            );
          },
        ),
        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: Column(
              children: [
                // generate qr label
                Text(
                  'Generate QR Code for a table:',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // table number input
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: _tableController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Table Number',
                      labelStyle: TextStyle(
                        color: _errorText != null ? Colors.red : Colors.black,
                      ),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _errorText != null ? Colors.red : Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _errorText != null ? Colors.red : Colors.black,
                          width: 2,
                        ),
                      ),
                      errorText: _errorText,
                      errorStyle: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // generate button
                ElevatedButton(
                  onPressed: _generateQrCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFBF9B6F),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Generate'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  // widget for qr code
  Widget _buildQrModal(String qrData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            'Scan Here',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 180,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            qrData,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
