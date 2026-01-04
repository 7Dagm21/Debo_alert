import 'package:flutter/material.dart';
import 'onboarding_three.dart';

class OnboardingTwo extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const OnboardingTwo({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _topBar(context, onToggleTheme),
            _content(
              icon: Icons.report,
              title: 'Report Instantly',
              desc: 'Report accidents and emergencies with one tap',
              dots: 1,
              buttonText: 'Next',
              isDark: isDark,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        OnboardingThree(onToggleTheme: onToggleTheme),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _topBar(BuildContext context, VoidCallback onToggleTheme) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Positioned(
    top: 8,
    left: 8,
    right: 8,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        IconButton(
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: onToggleTheme,
        ),
      ],
    ),
  );
}

Widget _content({
  required IconData icon,
  required String title,
  required String desc,
  required int dots,
  required String buttonText,
  required bool isDark,
  required VoidCallback onPressed,
}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 70, color: const Color(0xFFFF4D2D)),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == dots ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == dots
                      ? const Color(0xFFFF4D2D)
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE84A3C),
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            ),
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ],
      ),
    ),
  );
}
