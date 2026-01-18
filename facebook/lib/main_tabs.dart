import 'package:flutter/material.dart';
import 'home_page.dart';
import 'friends.dart';
import 'notifications.dart';
import 'design_system.dart';
import 'menu_page.dart';
import 'widgets.dart';

class MainTabs extends StatefulWidget {
  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: FBColors.white,
          title: const Text("facebook", style: FBText.header),
          actions: const [
            CircleIconButton(icon: Icons.search),
            SizedBox(width: 8),
            CircleIconButton(icon: Icons.menu),
            SizedBox(width: 12),
          ],
          bottom: TabBar(
            labelColor: FBColors.blue,
            unselectedLabelColor: FBColors.grey,
            indicatorColor: FBColors.blue,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.home, size: 28)),
              Tab(icon: Icon(Icons.people_outline, size: 28)),
              Tab(icon: Icon(Icons.notifications_none, size: 28)),
              Tab(icon: Icon(Icons.videogame_asset_outlined, size: 28)),
              Tab(icon: Icon(Icons.menu, size: 28)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const HomePage(),
            const FriendsPage(),
            const NotificationsPage(),
            const Center(child: Text('Gaming', style: TextStyle(fontSize: 24))),
            const MenuPage(),
          ],
        ),
      ),
    );
  }
}
