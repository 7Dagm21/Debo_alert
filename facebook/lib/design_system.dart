import 'package:flutter/material.dart';

class FBColors {
  static const Color blue = Color(0xFF1877F2);
  static const Color white = Colors.white;
  static const Color offWhite = Color(0xFFE4E6EB);
  static const Color lightGrey = Color(0xFFF0F2F5);
  static const Color grey = Color(0xFF65676B);
  static const Color black = Colors.black;
  static const Color green = Color(0xFF42B72A);
}

class FBText {
  static const TextStyle header = TextStyle(
    color: FBColors.blue,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.2,
  );

  static const TextStyle postName = TextStyle(
    color: FBColors.black,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const TextStyle postTime = TextStyle(
    color: FBColors.grey,
    fontSize: 12,
  );

  static const TextStyle body = TextStyle(
    color: FBColors.black,
    fontSize: 15,
  );

  static const TextStyle actionButton = TextStyle(
    color: FBColors.grey,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
}
