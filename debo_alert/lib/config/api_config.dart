// config/api_config.dart
class ApiConfig {
  // For local testing - use your PC IP address
  // static const baseUrl = 'http://10.2.71.11:5099';

  // For production - use your domain
  static const baseUrl = 'http://10.2.71.11:5099';

  // Helper method to get the correct URL based on environment
  static String getImageUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) {
      return '';
    }
    return '$baseUrl$relativePath';
  }
}
