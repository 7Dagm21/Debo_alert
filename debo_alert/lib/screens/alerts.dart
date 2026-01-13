import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

PreferredSizeWidget buildDeboAppBar(
  BuildContext context,
  VoidCallback onToggleTheme, {
  String title = 'Debo Alert',
}) {
  return AppBar(
    title: Row(
      children: [
        const Icon(Icons.notifications_active, color: Color(0xFFFF4D2D)),
        const SizedBox(width: 8),
        Text(title),
      ],
    ),
    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    actions: [
      IconButton(
        onPressed: onToggleTheme,
        icon: Icon(
          Theme.of(context).brightness == Brightness.dark
              ? Icons.light_mode
              : Icons.dark_mode,
        ),
      ),
    ],
  );
}

class AlertsPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const AlertsPage({super.key, required this.onToggleTheme});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> with RouteAware {
  final String apiUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:5099';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route changes
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when coming back to this page
    _fetchAlerts();
  }

  String selectedFilter = "All";
  List<dynamic> _alerts = [];
  bool _isLoading = false;
  String? _error;

  Widget _subtitle() {
    return Text(
      'Recent alerts near you',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAlerts();
  }

  Future<void> _fetchAlerts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _error = 'Not authenticated.';
          _isLoading = false;
        });
        return;
      }
      final token = await user.getIdToken();
      final response = await http.get(
        Uri.parse('$apiUrl/api/alerts'), // Use apiUrl here
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          _alerts = json.decode(response.body);
        });
      } else {
        setState(() {
          _error = 'Failed to load alerts: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: buildDeboAppBar(context, widget.onToggleTheme),
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

  IconData _alertIcon(String title) {
    final t = title.toLowerCase();
    if (t.contains('fire')) return Icons.local_fire_department;
    if (t.contains('car')) return Icons.directions_car;
    if (t.contains('medical')) return Icons.medical_services;
    if (t.contains('crime')) return Icons.security;
    if (t.contains('flood')) return Icons.water_damage;
    if (t.contains('animal')) return Icons.pets;
    if (t.contains('electric')) return Icons.electrical_services;
    return Icons.notifications;
  }

  Color _statusColor(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'verified':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'active':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _alertCard({
    required IconData icon,
    required String title,
    required String region,
    required String severity,
    required String status,
    required String createdAt,
    required Color color,
    String? description,
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
                if (description != null && description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      region,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      severity,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      createdAt,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
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
          // No status change menu for user page
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

  Widget _alertsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_alerts.isEmpty) {
      return const Center(child: Text('No alerts found.'));
    }
    // Optionally filter alerts based on selectedFilter
    final filteredAlerts = selectedFilter == "All"
        ? _alerts
        : _alerts
              .where(
                (a) =>
                    (a['status'] ?? '').toString().toLowerCase() ==
                    selectedFilter.toLowerCase(),
              )
              .toList();
    // Sort alerts by createdAt descending (most recent first)
    filteredAlerts.sort((a, b) {
      final aDate = DateTime.tryParse(a['createdAt'] ?? '') ?? DateTime(1970);
      final bDate = DateTime.tryParse(b['createdAt'] ?? '') ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });
    final recentAlerts = filteredAlerts.take(10).toList();
    return ListView.builder(
      itemCount: recentAlerts.length,
      itemBuilder: (context, index) {
        final alert = recentAlerts[index];
        return _alertCard(
          icon: _alertIcon(alert['title'] ?? ''),
          title: alert['title'] ?? 'Unknown',
          region: alert['region'] ?? 'Unknown',
          severity: alert['severity'] ?? 'Medium',
          status: alert['status'] ?? '',
          createdAt: alert['createdAt'] != null
              ? alert['createdAt'].toString().split('T')[0]
              : '',
          color: _statusColor(alert['status']),
          description: alert['description'],
        );
      },
    );
  }

  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search alerts...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
      onChanged: (query) {
        // Optionally implement search/filter logic here
        // For now, just ignore or show all
      },
    );
  }

  Widget _filterTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          tooltip: 'Filter',
          onPressed: () async {
            final filters = [
              'All',
              'Pending',
              'Verified',
              'Resolved',
              'Active',
            ];
            final result = await showDialog<String>(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: const Text('Filter Alerts'),
                  children: filters.map((filter) {
                    return SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, filter),
                      child: Row(
                        children: [
                          if (selectedFilter == filter)
                            const Icon(Icons.check, color: Colors.red),
                          if (selectedFilter == filter)
                            const SizedBox(width: 8),
                          Text(filter),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            );
            if (result != null && result != selectedFilter) {
              setState(() {
                selectedFilter = result;
              });
            }
          },
        ),
      ],
    );
  }
}
