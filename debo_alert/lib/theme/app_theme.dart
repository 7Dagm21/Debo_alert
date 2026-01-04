import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFE94B3C),
    scaffoldBackgroundColor: Colors.white,
    useMaterial3: true,
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFE94B3C),
    scaffoldBackgroundColor: const Color(0xFF1C0F0D),
    useMaterial3: true,
  );
}
