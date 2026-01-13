import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'alerts.dart';
import 'report.dart';
import 'profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Add this import

// Add a RouteObserver to listen for navigation events
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

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

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomePage({Key? key, required this.onToggleTheme}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  int _currentIndex = 0;
  LatLng? _currentPosition;
  StreamSubscription<Position>? _positionStream;

  IconData _categoryIcon(String? category) {
    switch ((category ?? '').toLowerCase()) {
      case 'fire':
        return Icons.local_fire_department;
      case 'accident':
        return Icons.car_crash;
      case 'medical':
        return Icons.medical_services;
      case 'crime':
        return Icons.security;
      case 'flood':
        return Icons.water;
      default:
        return Icons.warning;
    }
  }

  // Emergency reports state
  List<dynamic> _reports = [];
  bool _isLoadingReports = false;
  String? _reportsError;

  // Report filter state
  String _selectedReportFilter = 'All';

  // Use API base URL from .env
  final String apiUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:5099';

  @override
  void initState() {
    super.initState();
    _loadTabIndex();
    Geolocator.requestPermission().then((_) {
      _positionStream =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          ).listen((Position position) {
            setState(() {
              _currentPosition = LatLng(position.latitude, position.longitude);
            });
          });
    });
    _fetchReports();
  }

  Future<void> _loadTabIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentIndex = prefs.getInt('tabIndex') ?? 0;
    });
  }

  Future<void> _saveTabIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tabIndex', index);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to route changes
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when coming back to this page
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() {
      _isLoadingReports = true;
      _reportsError = null;
    });
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/report'), // Use apiUrl here
      );
      if (response.statusCode == 200) {
        setState(() {
          _reports = json.decode(response.body);
        });
      } else {
        setState(() {
          _reportsError = 'Failed to load reports: \\${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _reportsError = 'Error: \\${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoadingReports = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? buildDeboAppBar(context, widget.onToggleTheme)
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _homeContent(),
          AlertsPage(onToggleTheme: widget.onToggleTheme),
          ReportPage(onToggleTheme: widget.onToggleTheme),
          ProfilePage(
            onToggleTheme: widget.onToggleTheme,
            themeMode: Theme.of(context).brightness == Brightness.dark
                ? ThemeMode.dark
                : ThemeMode.light,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _saveTabIndex(index); // Save the selected tab
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF4D2D),
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Alerts",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: "Report"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _homeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Live Map with fixed height
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.grey[200],
            ),
            clipBehavior: Clip.antiAlias,
            child: _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : FlutterMap(
                    options: MapOptions(center: _currentPosition, zoom: 15),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 60,
                            height: 60,
                            point: _currentPosition!,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 36,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),
          // Report Emergency Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() => _currentIndex = 2); // Go to Report tab
              },
              icon: const Icon(Icons.warning),
              label: const Text("Report Emergency / ድንገተኛ ጥሪ"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4D2D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Filter icon button on right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(), // Placeholder for left side (could add title or leave empty)
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
                        title: const Text('Filter Reports'),
                        children: filters.map((filter) {
                          return SimpleDialogOption(
                            onPressed: () => Navigator.pop(context, filter),
                            child: Row(
                              children: [
                                if (_selectedReportFilter == filter)
                                  const Icon(Icons.check, color: Colors.red),
                                if (_selectedReportFilter == filter)
                                  const SizedBox(width: 8),
                                Text(filter),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                  if (result != null && result != _selectedReportFilter) {
                    setState(() {
                      _selectedReportFilter = result;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Reports list
          Builder(
            builder: (context) {
              final sortedReports = List<Map<String, dynamic>>.from(_reports);
              sortedReports.sort((a, b) {
                final aDate =
                    DateTime.tryParse(a['createdAt'] ?? '') ?? DateTime(1970);
                final bDate =
                    DateTime.tryParse(b['createdAt'] ?? '') ?? DateTime(1970);
                return bDate.compareTo(aDate);
              });
              final filteredReports = _selectedReportFilter == 'All'
                  ? sortedReports
                  : sortedReports
                        .where(
                          (r) =>
                              (r['status'] ?? '').toString().toLowerCase() ==
                              _selectedReportFilter.toLowerCase(),
                        )
                        .toList();
              return Column(
                children: filteredReports.map((report) {
                  final status = (report['status'] ?? 'Active').toString();
                  Color statusColor;
                  switch (status) {
                    case 'Pending':
                      statusColor = Colors.orange;
                      break;
                    case 'Verified':
                      statusColor = Colors.blue;
                      break;
                    case 'Resolved':
                      statusColor = Colors.green;
                      break;
                    default:
                      statusColor = Colors.red;
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.red.withOpacity(0.15),
                          child: Icon(
                            _categoryIcon(report['category']),
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${report['category'] ?? 'Emergency'}\n${report['description'] ?? ''}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
