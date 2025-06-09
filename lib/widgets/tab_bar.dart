import 'package:flutter/material.dart';

class TabBars extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final String? adminId;

  const TabBars({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.adminId,
  });

  @override
  Widget build(BuildContext context) {
    // colors
    const activeColor = Color(0xFFBF9B6F);
    const inactiveColor = Colors.grey;

    // tab bars icon
    final List<_TabItemData> tabItems =
        // tab for admin
        adminId != null
            ? [
              _TabItemData(0, Icons.qr_code, 'Table Qr Code'),
              _TabItemData(1, Icons.manage_accounts, 'Manage'),
            ]
            // tab for customer
            : [
              _TabItemData(0, Icons.home, 'Home'),
              _TabItemData(1, Icons.receipt_long, 'Orders'),
            ];

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 35),
      child: Container(
        height: 70,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x330D0A2C),
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              tabItems.map((item) {
                final color =
                    selectedIndex == item.index ? activeColor : inactiveColor;
                return _buildTabItem(
                  index: item.index,
                  icon: item.icon,
                  label: item.label,
                  color: color,
                  onTap: onTap,
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required String label,
    required Color color,
    required ValueChanged<int> onTap,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Transform.translate(
          offset: isSelected ? const Offset(0, -16) : Offset.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow:
                      isSelected
                          ? [
                            const BoxShadow(
                              color: Color(0x66000000),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ]
                          : [],
                ),
                child: Icon(
                  icon,
                  size: 25,
                  color: isSelected ? Colors.white : color,
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItemData {
  final int index;
  final IconData icon;
  final String label;

  _TabItemData(this.index, this.icon, this.label);
}
