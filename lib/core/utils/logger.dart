import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  static void debug(String? message) {
    if (message != null && message.isNotEmpty) {
      _logger.d(message);
    }
  }

  static void info(String? message) {
    if (message != null && message.isNotEmpty) {
      _logger.i(message);
    }
  }

  static void warning(String? message) {
    if (message != null && message.isNotEmpty) {
      _logger.w(message);
    }
  }

  static void error(String? message, [dynamic error, StackTrace? stackTrace]) {
    if (message != null && message.isNotEmpty) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }
}
