import 'package:flutter/material.dart';
import 'users_page.dart';
import 'reports_page.dart';
import 'alerts_page.dart';
import 'profile.dart';

class AdminHomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const AdminHomePage({super.key, required this.onToggleTheme});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  List<Widget> _buildPages(BuildContext context) {
    return [
      const UsersPage(),
      ReportsPage(),
      const AlertsPage(),
      ProfilePage(
        onToggleTheme: widget.onToggleTheme,
        themeMode: Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
      ),
    ];
  }

  final List<String> _pageTitles = [
    'Debo Alert',
    'Debo Alert',
    'Debo Alert',
    'Debo Alert',
    'Debo Alert',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.notifications_active, color: Color(0xFFFF4D2D)),
            const SizedBox(width: 8),
            Text(_pageTitles[_selectedIndex]),
          ],
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: _buildPages(context)[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF4D2D),
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        backgroundColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.backgroundColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Reports'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
