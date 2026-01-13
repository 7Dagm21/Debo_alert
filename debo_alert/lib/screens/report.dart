import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Add this import

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

class ReportPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const ReportPage({super.key, required this.onToggleTheme});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _descController = TextEditingController();
  String? _selectedCategory;
  XFile? _mediaFile;
  bool _isVideo = false;
  bool _isLoading = false;

  // Use API base URL from .env
  final String apiUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:5099';

  final List<String> _categories = [
    "Medical",
    "Car Accident",
    "Fire",
    "Earthquake",
    "Earth Fault",
    "Flood",
    "Desert Fire",
  ];

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Pick Image'),
              onTap: () async {
                final img = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 1920,
                  maxHeight: 1080,
                  imageQuality: 80,
                );
                Navigator.pop(context, img);
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text('Pick Video'),
              onTap: () async {
                final vid = await picker.pickVideo(
                  source: ImageSource.gallery,
                  maxDuration: Duration(seconds: 30),
                );
                Navigator.pop(context, vid);
              },
            ),
          ],
        ),
      ),
    );

    if (pickedFile != null) {
      // File size check - different for web
      if (!kIsWeb) {
        // For mobile/desktop
        final file = File(pickedFile.path);
        final bytes = await file.length();
        if (bytes > 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File must be less than 1MB.')),
          );
          return;
        }
      } else {
        // For web - check size differently
        final bytes = await pickedFile.readAsBytes();
        if (bytes.length > 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File must be less than 1MB.')),
          );
          return;
        }
      }

      setState(() {
        _mediaFile = pickedFile;
        _isVideo =
            pickedFile.path.endsWith('.mp4') ||
            pickedFile.path.endsWith('.mov') ||
            pickedFile.mimeType?.contains('video') == true;
      });
    }
  }

  Future<void> _submitReport() async {
    if (_selectedCategory == null || _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a category and enter a description.'),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);

    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (_) {}

    try {
      var dio = Dio();
      var uri = '$apiUrl/api/report'; // Use apiUrl here

      // Create form data
      var formData = FormData.fromMap({
        'Category': _selectedCategory!,
        'Description': _descController.text.trim(),
        'IsVideo': _isVideo.toString(),
        'Latitude': position?.latitude.toString() ?? '0.0',
        'Longitude': position?.longitude.toString() ?? '0.0',
      });

      // Handle file upload for both web and mobile
      if (_mediaFile != null) {
        // For web
        if (kIsWeb) {
          // Read file as bytes for web
          final bytes = await _mediaFile!.readAsBytes();
          final multipartFile = MultipartFile.fromBytes(
            bytes,
            filename: _mediaFile!.name,
          );
          formData.files.add(MapEntry('Media', multipartFile));
        }
        // For mobile/desktop
        else {
          formData.files.add(
            MapEntry(
              'Media',
              await MultipartFile.fromFile(
                _mediaFile!.path,
                filename: _mediaFile!.name,
              ),
            ),
          );
        }
      }

      var response = await dio.post(
        uri,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {'Accept': 'application/json'},
        ),
      );

      print('Status code: ${response.statusCode}');
      print('Response: ${response.data}');

      setState(() {
        _isLoading = false;
        _selectedCategory = null;
        _mediaFile = null;
        _descController.clear();
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Report submitted!')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to submit report.')));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDeboAppBar(context, widget.onToggleTheme),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Category:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((cat) {
                      final selected = _selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat, style: TextStyle(fontSize: 13)),
                        selected: selected,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = cat),
                        selectedColor: Colors.red.shade100,
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          color: selected ? Colors.red : Colors.black,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickMedia,
                        icon: Icon(Icons.attach_file),
                        label: Text('Attach Image/Video'),
                      ),
                      const SizedBox(width: 12),
                      if (_mediaFile != null)
                        _isVideo
                            ? Icon(Icons.videocam, color: Colors.red)
                            : Icon(Icons.image, color: Colors.green),
                      if (_mediaFile != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            _mediaFile!.name,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _submitReport,
                      icon: Icon(Icons.send),
                      label: Text('Submit Report'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4D2D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
