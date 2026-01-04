import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const FacebookClone());
}

class FacebookClone extends StatelessWidget {
  const FacebookClone({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
