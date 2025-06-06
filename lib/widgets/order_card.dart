import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final VoidCallback? onCancel;

  const OrderCard({super.key, required this.orderData, this.onCancel});

  // method to return color based on status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'preparing':
        return Colors.yellow.shade800;
      case 'completed':
        return Colors.green.shade600;
      case 'cancelled':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String label = orderData['item_label'] ?? 'Unknown Item';
    final int quantity = orderData['quantity'] ?? 0;
    final double menuPrice =
        (orderData['menu_price'] is num)
            ? (orderData['menu_price'] as num).toDouble()
            : 0.0;
    final String status = orderData['status'] ?? '';
    final String imageUrl =
        (orderData['imageUrl'] != null &&
                orderData['imageUrl'].toString().isNotEmpty)
            ? orderData['imageUrl']
            : 'assets/menus/nasi_lemak.png';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFAEAEAE), width: 1),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imageUrl,
                width: 60,
                height: 75,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color(0xFF132126),
                            fontFamily: 'Istok Web',
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'x$quantity',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF132126),
                          fontFamily: 'Istok Web',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 16,
                          color: _getStatusColor(status),
                          fontFamily: 'Istok Web',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'RM ${menuPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF132126),
                          fontFamily: 'Istok Web',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (status != 'Cancelled' && status != 'Completed')
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 24,
                                  title: const Text(
                                    'Cancel Order',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF132126),
                                    ),
                                  ),
                                  content: const Text(
                                    'Are you sure you want to cancel this order?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF444444),
                                    ),
                                  ),
                                  actionsPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.black54,
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      child: const Text('No'),
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFBF9B6F),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true && onCancel != null) {
                            onCancel!();
                          }
                        },

                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFFBF9B6F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel Order',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
