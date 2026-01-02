import 'package:flutter/foundation.dart';

/// Performance monitoring and optimization utilities
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  
  final Map<String, Stopwatch> _timers = {};

  factory PerformanceMonitor() {
    return _instance;
  }

  PerformanceMonitor._internal();

  /// Start measuring execution time for an operation
  void startTimer(String operationName) {
    _timers[operationName] = Stopwatch()..start();
  }

  /// Stop timer and get elapsed time
  Duration? stopTimer(String operationName) {
    final timer = _timers[operationName];
    if (timer != null) {
      timer.stop();
      final elapsed = timer.elapsed;
      _timers.remove(operationName);
      
      if (kDebugMode) {
        print('⏱️ Operation "$operationName" took ${elapsed.inMilliseconds}ms');
      }
      
      return elapsed;
    }
    return null;
  }

  /// Check if operation is taking too long (> 1 second)
  bool isSlowOperation(String operationName) {
    final timer = _timers[operationName];
    return timer != null && timer.elapsedMilliseconds > 1000;
  }

  /// Clear all timers
  void clearAll() {
    _timers.clear();
  }
}

/// Extension for easy performance monitoring
extension PerformanceX on Object {
  /// Measure execution time of an async function
  Future<T> measureAsync<T>(
    Future<T> Function() operation,
    String operationName,
  ) async {
    final monitor = PerformanceMonitor();
    monitor.startTimer(operationName);
    
    try {
      return await operation();
    } finally {
      monitor.stopTimer(operationName);
    }
  }

  /// Measure execution time of a sync function
  T measure<T>(
    T Function() operation,
    String operationName,
  ) {
    final monitor = PerformanceMonitor();
    monitor.startTimer(operationName);
    
    try {
      return operation();
    } finally {
      monitor.stopTimer(operationName);
    }
  }
}
