import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final bool showSearch;
  final String? pageTitle;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    this.showSearch = false,
    this.pageTitle,
    this.searchController,
    this.onSearchChanged,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 206,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0x3F000000),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFBF9B6F),
                image: DecorationImage(
                  image: AssetImage("assets/app-bar-bg.png"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Color(0xFF97662D),
                    BlendMode.srcATop,
                  ),
                ),
              ),
            ),
          ),

          // back button
          if (onBack != null)
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: onBack,
              ),
            ),

          // title row
          Positioned(
            top: 70,
            left: 25,
            right: 25,
            bottom: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: AssetImage('assets/restaurant-logo-white.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Restaurant Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Istok Web',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // search or page title
          Positioned(
            left: 25,
            right: 25,
            top: 130,
            child:
                showSearch
                    ? Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: onSearchChanged,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey[400],
                              size: 30,
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        pageTitle ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Istok Web',
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
