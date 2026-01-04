import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _autoVerification = true;

  final TextEditingController _mapsApiController = TextEditingController();
  final TextEditingController _smsApiController = TextEditingController();
  final TextEditingController _emailApiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Configure system preferences and integrations',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Notification Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification Settings',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage notification preferences',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Email Notifications
                  SwitchListTile(
                    title: Text(
                      'Email Notifications',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: const Text('Send email alerts for actual events'),
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() {
                        _emailNotifications = value;
                      });
                    },
                  ),

                  const Divider(),

                  // SMS Notifications
                  SwitchListTile(
                    title: Text(
                      'SMS Notifications',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: const Text('SMS alerts to be in administration'),
                    value: _smsNotifications,
                    onChanged: (value) {
                      setState(() {
                        _smsNotifications = value;
                      });
                    },
                  ),

                  const Divider(),

                  // Auto Verification
                  SwitchListTile(
                    title: Text(
                      'Auto-Verification',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: const Text(
                      'Automatically verify reports from trusted users',
                    ),
                    value: _autoVerification,
                    onChanged: (value) {
                      setState(() {
                        _autoVerification = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // API Configuration
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'API Configuration',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage external service integration',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Google Maps API
                  Text(
                    'Google Maps API Key',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _mapsApiController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Google Maps API Key',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {},
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // SMS Gateway API
                  Text(
                    'SMS Gateway API Key',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _smsApiController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter SMS Gateway API Key',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {},
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Email Service API
                  Text(
                    'Email Service API Key',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailApiController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Email Service API Key',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {},
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle save settings
                      },
                      child: const Text('Save Settings'),
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
