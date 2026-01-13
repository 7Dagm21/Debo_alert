import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Add this import

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fire':
        return Icons.local_fire_department;
      case 'car accident':
      case 'accident':
        return Icons.directions_car;
      case 'medical':
      case 'health':
        return Icons.medical_services;
      case 'crime':
        return Icons.security;
      case 'flood':
        return Icons.water_damage;
      case 'earthquake':
        return Icons.public;
      case 'animal':
        return Icons.pets;
      case 'electric':
      case 'electricity':
        return Icons.electrical_services;
      default:
        return Icons.report;
    }
  }

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _reports = [];
  List<Map<String, dynamic>> _filteredReports = [];

  // Use API base URL from .env
  final String apiUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:5099';

  @override
  void initState() {
    super.initState();
    _fetchReports();
    _searchController.addListener(_filterReports);
  }

  Future<void> _fetchReports() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/report'), // Use apiUrl here
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _reports = data
              .map<Map<String, dynamic>>(
                (report) => {
                  'id': report['id'],
                  'userName': '', // No userName in backend
                  'location':
                      (report['latitude'] != null &&
                          report['longitude'] != null)
                      ? 'Lat: ${report['latitude']}, Lng: ${report['longitude']}'
                      : 'Unknown',
                  'type': report['category'] ?? 'Unknown',
                  'time': (report['timestamp'] ?? '').toString().split('T')[0],
                  'status': report['status'] ?? 'Pending',
                  'color': _statusColor(report['status'] ?? 'Pending'),
                },
              )
              .toList();
          _filteredReports = List.from(_reports);
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Verified':
        return Colors.blue;
      case 'Resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _filterReports() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredReports = List.from(_reports);
      } else {
        _filteredReports = _reports.where((report) {
          return report['userName'].toLowerCase().contains(query) ||
              report['location'].toLowerCase().contains(query) ||
              report['type'].toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _updateStatus(int index, String newStatus) async {
    final report = _filteredReports[index];
    try {
      final response = await http.patch(
        Uri.parse('$apiUrl/api/report/${report['id']}'), // Use apiUrl here
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': newStatus}),
      );
      if (response.statusCode == 200) {
        await _fetchReports();
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reports Management',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Review and manage emergency reports',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search reports...',
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.all(16),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterReports();
                        },
                      )
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Main Stats Grid
          SizedBox(
            height: 380,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
              children: [
                _buildStatCard(
                  context,
                  '${_reports.length}',
                  'Total Reports',
                  Icons.report,
                ),
                _buildStatCard(
                  context,
                  '${_reports.where((r) => r['status'] == 'Pending').length}',
                  'Pending',
                  Icons.pending,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Verified and Resolved Cards Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  '${_reports.where((r) => r['status'] == 'Verified').length}',
                  'Verified',
                  Icons.verified,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  '${_reports.where((r) => r['status'] == 'Resolved').length}',
                  'Resolved',
                  Icons.check_circle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Reports Table
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Emergency Reports',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        _showFilterDialog();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('User Name')),
                      DataColumn(label: Text('Location')),
                      DataColumn(label: Text('Emergency Type')),
                      DataColumn(label: Text('Time')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: _filteredReports.asMap().entries.map((entry) {
                      final index = entry.key;
                      final report = entry.value;

                      return DataRow(
                        cells: [
                          DataCell(Text(report['userName'])),
                          DataCell(Text(report['location'])),
                          DataCell(
                            Row(
                              children: [
                                Icon(
                                  _categoryIcon(report['type']),
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(width: 8),
                                Text(report['type']),
                              ],
                            ),
                          ),
                          DataCell(Text(report['time'])),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: report['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                report['status'],
                                style: TextStyle(
                                  color: report['color'],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            PopupMenuButton<String>(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Row(
                                    children: [
                                      Icon(Icons.visibility, size: 18),
                                      SizedBox(width: 8),
                                      Text('View Details'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'pending',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.pending,
                                        size: 18,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Mark Pending'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'verified',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Mark Verified'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'resolved',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Mark Resolved'),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'view') {
                                  _viewReportDetails(report);
                                } else {
                                  String newStatus = '';
                                  switch (value) {
                                    case 'pending':
                                      newStatus = 'Pending';
                                      break;
                                    case 'verified':
                                      newStatus = 'Verified';
                                      break;
                                    case 'resolved':
                                      newStatus = 'Resolved';
                                      break;
                                  }
                                  _updateStatus(index, newStatus);
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          
        ],
      ),
    );
  }

  void _viewReportDetails(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('User:', report['userName']),
            _buildDetailRow('Location:', report['location']),
            _buildDetailRow('Type:', report['type']),
            _buildDetailRow('Time:', report['time']),
            _buildDetailRow('Status:', report['status']),
            const SizedBox(height: 16),
            const Text(
              'Additional Information:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'Emergency reported via mobile app. First responders have been notified.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4D2D),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Take Action',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Reports'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Reports'),
              leading: const Icon(Icons.all_inclusive),
              onTap: () {
                setState(() {
                  _filteredReports = List.from(_reports);
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Pending Only'),
              leading: const Icon(Icons.pending, color: Colors.orange),
              onTap: () {
                setState(() {
                  _filteredReports = _reports
                      .where((r) => r['status'] == 'Pending')
                      .toList();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Verified Only'),
              leading: const Icon(Icons.verified, color: Colors.blue),
              onTap: () {
                setState(() {
                  _filteredReports = _reports
                      .where((r) => r['status'] == 'Verified')
                      .toList();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Resolved Only'),
              leading: const Icon(Icons.check_circle, color: Colors.green),
              onTap: () {
                setState(() {
                  _filteredReports = _reports
                      .where((r) => r['status'] == 'Resolved')
                      .toList();
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: const Color(0xFFFF4D2D)),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF4D2D),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
