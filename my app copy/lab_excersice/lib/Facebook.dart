import 'package:flutter/material.dart';

class FacebookScreen extends StatelessWidget {
  const FacebookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // pure clean background
      body: Center(
        child: Icon(
          Icons.facebook,
          color: Color(0xFF1877F2), // Facebook blue
          size: 120, // big + bold
        ),
      ),
    );
  }
}
