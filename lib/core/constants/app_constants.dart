class AppConstants {
  // App Info
  static const String appName = 'Network App';
  static const String appVersion = '1.0.0';
  
  // API Constants
  static const String baseUrl = 'https://api.example.com';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Map Constants
  static const double defaultZoom = 15.0;
  static const double defaultLatitude = 31.5;
  static const double defaultLongitude = 34.5;
  
  // Storage Keys
  static const String keyLanguage = 'language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyNotifications = 'notifications_enabled';
  
  // Network Constants
  static const int pingTimeout = 5000; // milliseconds
  static const int networkCheckInterval = 30; // seconds
  
  // Tower Status Colors
  static const String accessibleColor = '#4CAF50';
  static const String notAccessibleColor = '#F44336';
  static const String unknownColor = '#FFC107';
}
