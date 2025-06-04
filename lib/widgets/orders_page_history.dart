import 'package:flutter/material.dart';

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 305,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFAEAEAE)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row of 2 images
          Row(
            children: [
              SizedBox(height: 100),
              const SizedBox(width: 10),
              _buildFoodImage(
                  "https://placehold.co/59x75"),
              const SizedBox(width: 30),
              _buildFoodImage(
                  "https://placehold.co/59x75"),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    '9 May 2025',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Istok Web',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'RM14.50',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Istok Web',
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '3 Items >',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontFamily: 'Istok Web',
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 1),
          const Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Nasi Lemak',
                style: TextStyle(
                  fontFamily: 'Istok Web',
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 15),
              Text(
                'Bihun Goreng',
                style: TextStyle(
                  fontFamily: 'Istok Web',
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          // Divider
          const Divider(height: 50, color: Color.fromARGB(255, 220, 220, 220),),
          // Rate Your Meal Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 215, 215, 215)), // Light gray border
              borderRadius: BorderRadius.circular(3),
              color: const Color(0xFFF5F5F5), // Light gray background
            ),
            child: Row(
              children: const [
                Text(
                  'Rate Your Meal',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Istok Web',
                    color: Color.fromARGB(255, 160, 160, 160)
                  ),
                ),
                Spacer(), // Align stars to the right               
                Icon(Icons.star, size: 20, color: Color(0xFFC3C2C2),),
                Icon(Icons.star, size: 20, color: Color(0xFFC3C2C2)),
                Icon(Icons.star, size: 20, color: Color(0xFFC3C2C2)),
                Icon(Icons.star, size: 20, color: Color(0xFFC3C2C2)),
                Icon(Icons.star, size: 20, color: Color(0xFFC3C2C2)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Status and Buttons
          Row(
            children: [
              SizedBox(width: 10),
              const Text(
                'Completed',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Istok Web',
                  color: Color(0xFF000000),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 60),
              const SizedBox(width: 30),

             Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBF9B6F)), // Light gray border
              borderRadius: BorderRadius.circular(3),
              color: const Color(0xFFF5F5F5), // Light gray background
            ),
            child: Row(
              children: const [
                Text(
                  'Rate & Tip',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Istok Web',
                    color: Color(0xFFBF9B6F),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(width: 2),
              Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBF9B6F)), // Light gray border
              borderRadius: BorderRadius.circular(3),
              color: const Color(0xFFBF9B6F), 
            ),
            child: Row(
              children: const [
                Text(
                  'Re-Order',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Istok Web',
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ],
            ),
          ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFoodImage(String url) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF7E7E7E), width: 0.5),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// part ni dah siap