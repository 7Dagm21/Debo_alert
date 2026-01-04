import 'package:flutter/material.dart';

class DeboBorder extends StatelessWidget {
  final Widget child;
  const DeboBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.92,
      height: size.height * 0.92,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF8B5A5A), // muted rose border
          width: 4,
        ),
        color: const Color(0xFF241414),
      ),
      child: child,
    );
  }
}
