import 'package:flutter/material.dart';

class AppTextTheme {
  // Change this to your font family name (must match pubspec.yaml)
  // Options: 'Vazir', 'IRANSans', 'Shabnam', etc.
  static const String defaultFont = 'Vazir';
  
  // Helper method to get TextStyle with default font
  static TextStyle getTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: defaultFont,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
  
  static TextTheme get lightTextTheme => TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: defaultFont,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontFamily: defaultFont,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          fontFamily: defaultFont,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontFamily: defaultFont,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          fontFamily: defaultFont,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontFamily: defaultFont,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: defaultFont,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
          fontFamily: defaultFont,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.black54,
          fontFamily: defaultFont,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
          fontFamily: defaultFont,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
          fontFamily: defaultFont,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
          fontFamily: defaultFont,
        ),
      );
}
