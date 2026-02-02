import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String imageUrl; // the background image

  const HeaderWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight, // full device height
      width: double.infinity,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(child: Image.network(imageUrl, fit: BoxFit.cover)),

          // Optional overlay for darkening the image
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          // Centered texts
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'تزریق پلاستیک داوودی',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  'خلق قطعات با کیفیت و دقت بی‌نظیر',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),

                SizedBox(height: 16),
                Text(
                  'تولید حرفه‌ای قطعات پلاستیکی برای صنایع مختلف',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 26),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
