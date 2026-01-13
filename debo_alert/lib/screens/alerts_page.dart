import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Add this import

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _regionSearchController = TextEditingController();

  String _selectedRegion = 'Bole Road';
  String _selectedSeverity = 'Medium';

  // Add this line to get the API base URL from .env
  final String apiUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:5099';

  Future<void> _sendAdminAlert() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Not authenticated.')));
        return;
      }
      final token = await user.getIdToken();
      final response = await http.post(
        Uri.parse('$apiUrl/api/alerts'), // Use apiUrl here
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'title': _titleController.text,
          'region': _selectedRegion,
          'severity': _selectedSeverity,
          'description': _descriptionController.text,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        _titleController.clear();
        _descriptionController.clear();
        setState(() {}); // Refresh UI
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alert sent successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send alert: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<List<Map<String, dynamic>>> _fetchRecentAlerts() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];
      final token = await user.getIdToken();
      final response = await http.get(
        Uri.parse('$apiUrl/api/alerts'), // Use apiUrl here
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  final List<String> _regions = [
    'Bole Road',
    'Kazanchis',
    'Arat Kilo',
    'Piazza',
    'Megenagna',
    'Mexico',
    'Saris',
    'Gullele',
    'Addis Ketema',
    'Lideta',
    'Kirkos',
    'Yeka',
    'Nifas Silk',
    'Akaki Kality',
    'Bole',
    'Lafto',
    'Kolfe Keranio',
    'Gurd Shola',
    'CMC',
    'Ayat',
    'Summit',
    'Jemo',
    'Gerji',
    'Bambis',
    'Torhailoch',
    'Bole Medhanialem',
    'Bole Michael',
    'Bole Bulbula',
    'Bole Atlas',
    'Bole Japan',
    'Bole Rwanda',
    'Bole Dembel',
    'Bole Olympia',
    'Bole Friendship',
    'Bole Chechnya',
    'Bole Gotera',
    'Bole Fanta',
    'Bole Tele',
    'Bole Edna Mall',
    'Bole Airport',
    'Bole Millennium',
    'Bole Sheger',
    'Bole Goro',
    'Bole Yerer',
    'Bole Arabsa',
    'Bole Ayat',
    'Bole Summit',
    'Bole Gerji',
    'Bole Sarbet',
    'Bole Bisrate Gabriel',
    'Bole 22',
    'Bole 24',
    'Bole 23',
    'Bole 25',
    'Bole 26',
    'Bole 27',
    'Bole 28',
    'Bole 29',
    'Bole 30',
    'Bole 31',
    'Bole 32',
    'Bole 33',
    'Bole 34',
    'Bole 35',
    'Bole 36',
    'Bole 37',
    'Bole 38',
    'Bole 39',
    'Bole 40',
    'Bole 41',
    'Bole 42',
    'Bole 43',
    'Bole 44',
    'Bole 45',
    'Bole 46',
    'Bole 47',
    'Bole 48',
    'Bole 49',
    'Bole 50',
  ];

  final List<String> _severities = ['Low', 'Medium', 'High', 'Critical'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Broadcasts
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Broadcasts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchRecentAlerts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: Theme.of(context).textTheme.titleLarge,
                      );
                    }
                    final alerts = snapshot.data ?? [];
                    if (alerts.isEmpty) {
                      return const Text('No recent alerts.');
                    }
                    return Column(
                      children: alerts.map((alert) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(top: 6),
                                decoration: BoxDecoration(
                                  color: _getSeverityColor(
                                    alert['severity'] ?? 'low',
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      alert['title'] ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getSeverityColor(
                                              alert['severity'] ?? 'low',
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            alert['severity'] ?? '',
                                            style: TextStyle(
                                              color: _getSeverityColor(
                                                alert['severity'] ?? 'low',
                                              ),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          alert['region'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.circle,
                                          size: 4,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          alert['createdAt'] != null
                                              ? alert['createdAt']
                                                    .toString()
                                                    .split('T')[0]
                                              : '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (String newStatus) async {
                                  await _updateAlertStatus(
                                    alert['id'],
                                    newStatus,
                                  );
                                  setState(() {});
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'Active',
                                        child: Text('Set Active'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'Resolved',
                                        child: Text('Set Resolved'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'Dismissed',
                                        child: Text('Set Dismissed'),
                                      ),
                                    ],
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
          ),
          const SizedBox(height: 8),
          Text(
            'Send emergency alerts to users in specific regions',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Create New Alert Form
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Alert',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Alert Title
                _buildFormField(
                  label: 'Alert Title',
                  hint: 'Enter alert title',
                  controller: _titleController,
                ),

                const SizedBox(height: 16),

                // Target Region
                Text(
                  'Target Region',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedRegion,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: _regions.map((region) {
                      return DropdownMenuItem(
                        value: region,
                        child: Text(region),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRegion = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Severity Level
                Text(
                  'Security Level',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedSeverity,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: _severities.map((severity) {
                      return DropdownMenuItem(
                        value: severity,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _getSeverityColor(severity),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(severity),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSeverity = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Alert Description
                _buildFormField(
                  label: 'Alert Description',
                  hint: 'Provide detailed information about the alert',
                  controller: _descriptionController,
                  maxLines: 3,
                ),

                const SizedBox(height: 24),

                // Send Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _sendAdminAlert,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4D2D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Send Alert Broadcast',
                      style: TextStyle(color: Colors.white),
                    ),
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

  Widget _buildFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _updateAlertStatus(dynamic alertId, String newStatus) async {
    try {
      final user = await FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final token = await user.getIdToken();
      final response = await http.patch(
        Uri.parse('$apiUrl/api/alerts/$alertId/status'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(newStatus), // Send raw string, not an object
      );
      if (response.statusCode == 200) {
        setState(() {});
      } else {
        // Optionally show error
      }
    } catch (e) {
      // Optionally handle error
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'critical':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusChips(String status) {
    Color color;
    String label;

    switch (status) {
      case 'Pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'Verified':
        color = Colors.blue;
        label = 'Verified';
        break;
      case 'Resolved':
        color = Colors.green;
        label = 'Resolved';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }
}
