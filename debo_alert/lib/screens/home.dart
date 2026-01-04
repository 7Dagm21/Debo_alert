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

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomePage({Key? key, required this.onToggleTheme}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng? _currentPosition;
  int _currentIndex = 0;
  StreamSubscription<Position>? _positionStream;

  // Emergency reports state
  List<dynamic> _reports = [];
  bool _isLoadingReports = false;
  String? _reportsError;

  @override
  void initState() {
    super.initState();
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
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() {
      _isLoadingReports = true;
      _reportsError = null;
    });
    try {
      // TODO: Replace with your actual API base URL
      final response = await http.get(
        Uri.parse('http://10.2.71.11:5099/api/report'),
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
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: const Text('Live Map'),
              actions: [
                IconButton(
                  icon: Icon(Icons.brightness_6),
                  onPressed: widget.onToggleTheme,
                ),
              ],
            )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _homeContent(),
          AlertsPage(onToggleTheme: widget.onToggleTheme),
          ReportPage(onToggleTheme: widget.onToggleTheme),
          ProfilePage(onToggleTheme: widget.onToggleTheme, themeMode: Theme.of(context).brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
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
          // Other content below
          const Text(
            "Nearby Alerts",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_isLoadingReports)
            const Center(child: CircularProgressIndicator()),
          if (_reportsError != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _reportsError!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          if (!_isLoadingReports && _reportsError == null)
            ..._reports.map(
              (report) => Container(
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
                        report['isVideo'] == true
                            ? Icons.videocam
                            : Icons.car_crash,
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
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Active",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
