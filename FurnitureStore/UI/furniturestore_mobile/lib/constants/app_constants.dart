import 'dart:ui';

class AppConstants {
  // For development, use environment variable or default
  // For production, replace with your actual domain/IP
  static const String baseUrl =
      String.fromEnvironment('BASE_URL', defaultValue: 'http://10.0.2.2:7015');

  static const String defaultImagePath = 'assets/images/furniture_logo.jpg';

  // Helper method to get the full image URL
  static String getImageUrl(int imageId) {
    return '$baseUrl/api/ProductPicture/direct-image/$imageId';
  }

  static String getDecorationItemImageUrl(int imageId) {
    return '$baseUrl/api/DecorationItem/direct-image/$imageId';
  }

  // Helper method to get path-based image URL
  static String getPathImageUrl(String imagePath) {
    return '$baseUrl$imagePath';
  }

  static const Map<String, Color> colors = {
    'primary': Color(0xFF1D3557),
    'accent': Color(0xFF70BC69),
    'background': Color(0xFFE0E0E0),
  };

  static const Map<String, double> spacing = {
    'small': 6.0,
    'medium': 8.0,
    'large': 16.0,
  };
}
