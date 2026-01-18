import 'package:flutter/material.dart';
import 'design_system.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const CircleIconButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: FBColors.offWhite,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: FBColors.black, size: 22),
      ),
    );
  }
}
