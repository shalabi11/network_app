import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool get isValidUrl {
    try {
      final uri = Uri.parse(this);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}

extension ContextExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}

extension DateTimeExtension on DateTime {
  String toFormattedString() {
    return '$day/${month.toString().padLeft(2, '0')}/$year ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}

extension IntExtension on int {
  String get signalStrengthLabel {
    if (this >= -50) return 'Excellent';
    if (this >= -60) return 'Good';
    if (this >= -70) return 'Fair';
    if (this >= -80) return 'Weak';
    return 'Very Weak';
  }

  Color get signalStrengthColor {
    if (this >= -50) return Colors.green;
    if (this >= -60) return Colors.lightGreen;
    if (this >= -70) return Colors.orange;
    if (this >= -80) return Colors.deepOrange;
    return Colors.red;
  }
}
