import 'package:flutter/material.dart';

class CustomerOrderCard extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final VoidCallback? onMarkCompleted;

  const CustomerOrderCard({
    super.key,
    required this.orderData,
    this.onMarkCompleted,
  });

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
        (orderData['imageUrl']?.toString().isNotEmpty ?? false)
            ? orderData['imageUrl']
            : 'assets/menus/nasi_lemak.png';

    final String tableNumber = orderData['table_number']?.toString() ?? 'N/A';

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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF132126),
                                fontFamily: 'Istok Web',
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Table No: $tableNumber',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF555555),
                                fontFamily: 'Istok Web',
                              ),
                            ),
                          ],
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
                  if (status != 'Completed' && status != 'Cancelled')
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: onMarkCompleted,
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
                          'Mark as Complete',
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
