import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'design_system.dart';
import 'widgets.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FBColors.lightGrey,
      body: ListView(
        children: [_buildHeader(), _buildShortcutGrid(), _buildUtilityList()],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Menu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              CircleIconButton(icon: Icons.settings, onTap: () {}),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: FBColors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/dag.jpg'),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Dagi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: FBColors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _buildShortcutItem(Icons.group, 'Groups', Colors.blue),
        _buildShortcutItem(Icons.storefront, 'Marketplace', Colors.blue),
        _buildShortcutItem(Icons.history, 'Memories', Colors.blue),
        _buildShortcutItem(Icons.bookmark, 'Saved', Colors.purple),
        _buildShortcutItem(Icons.flag, 'Pages', Colors.orange),
        _buildShortcutItem(Icons.event, 'Events', Colors.red),
      ],
    );
  }

  Widget _buildShortcutItem(IconData icon, String title, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: FBColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildUtilityList() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildUtilityItem(Icons.help, 'Help & Support'),
        const Divider(height: 1, indent: 50),
        _buildUtilityItem(Icons.settings, 'Settings & Privacy'),
        const Divider(height: 1, indent: 50),
        _buildUtilityItem(Icons.logout, 'Log Out'),
      ],
    );
  }

  Widget _buildUtilityItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: FBColors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: FBColors.grey),
      onTap: () {
        if (title == 'Log Out') {
          FirebaseAuth.instance.signOut();
        }
      },
    );
  }
}
