import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Add this import

PreferredSizeWidget buildDeboAppBar(
  BuildContext context,
  VoidCallback onToggleTheme, {
  String title = 'Debo Alert',
  List<Widget>? actions,
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
    actions:
        actions ??
        [
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

class ProfilePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  const ProfilePage({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  final phoneCtrl = TextEditingController();
  XFile? _pickedImage; // Changed from File to XFile
  Uint8List? _imageBytes; // For storing image bytes (works on web)
  String? _profileImageUrl;
  String? _email;
  bool _loading = true;

  // Use API base URL from .env
  final String apiUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:5099';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    print('Attempting to connect to: $apiUrl/api/userprofile/me');

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user logged in');
      return;
    }

    try {
      final token = await user.getIdToken();
      print(
        'Got Firebase token: ${token != null ? token.substring(0, 20) : 'null'}...',
      );

      final response = await http.get(
        Uri.parse('$apiUrl/api/userprofile/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _email = data['email'];
          phoneCtrl.text = data['phoneNumber'] ?? '';
          _profileImageUrl = data['profileImageUrl'];
          _loading = false;
        });
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error details: $e');
      print('Error type: ${e.runtimeType}');

      // Check specific error types
      if (e is SocketException) {
        print('SocketException - cannot connect to host');
      } else if (e is http.ClientException) {
        print('ClientException - HTTP request failed');
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_email == null) return;

    setState(() => _loading = true);

    try {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$apiUrl/api/userprofile/me'),
      );

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';

      // Add form fields
      request.fields['phoneNumber'] = phoneCtrl.text;

      // Add image file if picked
      if (_pickedImage != null) {
        // Get file bytes
        final bytes = await _pickedImage!.readAsBytes();

        // Get file extension
        final extension = path.extension(_pickedImage!.name).toLowerCase();

        // Determine content type
        String contentType;
        switch (extension) {
          case '.jpg':
          case '.jpeg':
            contentType = 'image/jpeg';
            break;
          case '.png':
            contentType = 'image/png';
            break;
          case '.gif':
            contentType = 'image/gif';
            break;
          default:
            contentType = 'application/octet-stream';
        }

        final multipartFile = http.MultipartFile.fromBytes(
          'profileImage',
          bytes,
          filename: 'profile${DateTime.now().millisecondsSinceEpoch}$extension',
          contentType: http.MediaType.parse(contentType),
        );

        request.files.add(multipartFile);
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Clear picked image after successful upload
        _pickedImage = null;
        _imageBytes = null;

        // Reload profile to get updated image URL
        await _loadProfile();

        // Exit edit mode
        setState(() => isEditing = false);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Profile saved successfully')));
      } else {
        throw Exception('Failed to save profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: ${e.toString()}')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildProfileImage() {
    // If we have a picked image (not uploaded yet)
    if (_imageBytes != null) {
      return CircleAvatar(
        radius: 40,
        backgroundColor: const Color.fromARGB(0, 97, 73, 156),
        backgroundImage: MemoryImage(_imageBytes!),
      );
    }
    // If we have a profile image URL from backend
    if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      String url = _profileImageUrl!;
      if (!url.startsWith('http')) {
        url = '$apiUrl$url'; // Use apiUrl here
      }
      return ClipOval(
        child: Image.network(
          url,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const CircleAvatar(
              radius: 40,
              backgroundColor: Color.fromARGB(0, 113, 103, 138),
              child: Icon(Icons.person, size: 40),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
        ),
      );
    }
    // Default avatar
    return const CircleAvatar(
      radius: 40,
      backgroundColor: Color.fromARGB(0, 113, 103, 138),
      child: Icon(Icons.person, size: 40),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _pickedImage = pickedFile;
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeMode == ThemeMode.dark;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Remove Scaffold and AppBar here!
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    _buildProfileImage(),
                    if (isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 2,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 18),
                            color: Colors.white,
                            onPressed: _pickImage,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _email ?? 'No email',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                isEditing
                    ? TextField(
                        controller: phoneCtrl,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Theme.of(
                            context,
                          ).inputDecorationTheme.fillColor,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            phoneCtrl.text.isEmpty ? 'Not set' : phoneCtrl.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Theme Toggle Card
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: widget.onToggleTheme,
                    tooltip: "Toggle theme",
                  ),
                  title: Text(
                    "Theme",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  subtitle: Text(
                    isDark ? "Dark Mode" : "Light Mode",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, '/sign_in');
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
