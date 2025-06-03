import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 354,
      height: 174,
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 354,
              height: 174,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFFAEAEAE)),
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 19,
            top: 16,
            child: Container(
              width: 59,
              height: 75,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://placehold.co/59x75"),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0xFF7E7E7E)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            left: 95,
            top: 16,
            child: Text(
              'Nasi Lemak',
              style: TextStyle(
                color: Color(0xFF132126),
                fontSize: 18,
                fontFamily: 'Istok Web',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
            left: 322,
            top: 16,
            child: Text(
              'x1',
              style: TextStyle(
                color: Color(0xFF132126),
                fontSize: 18,
                fontFamily: 'Istok Web',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
            left: 95,
            top: 42,
            child: Text(
              '- Extra sambal\n- Extra nasi\n- No ikan bilis\n- No kacang',
              style: TextStyle(
                color: Color(0xFF7E7E7E),
                fontSize: 15,
                fontFamily: 'Istok Web',
                fontWeight: FontWeight.w400,
                height: 1.20,
              ),
            ),
          ),
          Positioned(
            left: 19,
            top: 137,
            child: Text(
              'Preparing...',
              style: TextStyle(
                color: Color(0xFFFF4040),
                fontSize: 16,
                fontFamily: 'Istok Web',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
            left: 276,
            top: 138,
            child: Text(
              'RM6.50',
              style: TextStyle(
                color: Color(0xFF132126),
                fontSize: 18,
                fontFamily: 'Istok Web',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
