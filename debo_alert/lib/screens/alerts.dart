import 'package:flutter/material.dart';

class AlertsPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const AlertsPage({super.key, required this.onToggleTheme});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // 🔁 APP BAR WITH THEME TOGGLE
      appBar: AppBar(
        elevation: 0,
        title: const Text("All Alerts"),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _subtitle(),
              const SizedBox(height: 12),
              _searchBar(),
              const SizedBox(height: 12),
              _filterTabs(),
              const SizedBox(height: 16),
              Expanded(child: _alertsList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subtitle() {
    return const Text(
      "ሁሉም ማስጠንቀቂያዎች",
      style: TextStyle(color: Colors.grey, fontSize: 12),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: _cardStyle(),
      child: const TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          hintText: "Search alerts...",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _filterTabs() {
    return Row(
      children: [
        _filterButton("All"),
        const SizedBox(width: 8),
        _filterButton("Active"),
        const SizedBox(width: 8),
        _filterButton("Resolved"),
      ],
    );
  }

  Widget _filterButton(String label) {
    final isSelected = selectedFilter == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedFilter = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFF4D2D)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _alertsList() {
    return ListView(
      children: [
        _alertCard(
          icon: Icons.car_crash,
          title: "Car Accident on Bole Road",
          distance: "1.2 km away",
          time: "5 mins ago",
          status: "Active",
          color: Colors.red,
        ),
        _alertCard(
          icon: Icons.local_fire_department,
          title: "Fire Reported in Piazza",
          distance: "3.5 km away",
          time: "12 mins ago",
          status: "Verified",
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _alertCard({
    required IconData icon,
    required String title,
    required String distance,
    required String time,
    required String status,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: _cardStyle(),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  "$distance • $time",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardStyle() {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
    );
  }
}
