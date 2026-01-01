import 'dart:math';
import 'package:dio/dio.dart';

/// Mock interceptor for development and testing
/// Provides sample tower data without requiring a backend API
class MockInterceptor extends Interceptor {
  final Random _random = Random();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Intercept tower-related requests
    if (options.path.contains('/towers/nearby')) {
      // Simulate realistic network delay
      await Future.delayed(const Duration(milliseconds: 200));

      final latitude = options.queryParameters['latitude'] as double? ?? 0.0;
      final longitude = options.queryParameters['longitude'] as double? ?? 0.0;

      // Generate more realistic mock tower data near the requested location
      final mockTowers = _generateMockTowers(latitude, longitude, 8);

      final mockResponse = {'towers': mockTowers};

      return handler.resolve(
        Response(requestOptions: options, statusCode: 200, data: mockResponse),
      );
    }

    // Intercept tower by ID requests
    if (options.path.contains('/towers/') &&
        !options.path.contains('/towers/nearby') &&
        !options.path.contains('/ping') &&
        !options.path.contains('/stats')) {
      await Future.delayed(const Duration(milliseconds: 300));

      final towerData = {
        'id': '1',
        'name': 'Tower Alpha',
        'latitude': 36.2118763,
        'longitude': 37.1163095,
        'isAccessible': true,
        'signalStrength': 85,
        'status': 'active',
        'networkType': '4G LTE',
        'pingLatency': 25,
        'uploadSpeed': 15.5,
        'downloadSpeed': 45.2,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      return handler.resolve(
        Response(requestOptions: options, statusCode: 200, data: towerData),
      );
    }

    // Intercept ping requests
    if (options.path.contains('/ping')) {
      await Future.delayed(Duration(milliseconds: 50 + _random.nextInt(150)));

      final latency = 15 + _random.nextInt(50);
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'latency': latency},
        ),
      );
    }

    // Intercept stats update requests
    if (options.path.contains('/stats')) {
      await Future.delayed(const Duration(milliseconds: 400));

      final towerData = {
        'id': '1',
        'name': 'Tower Alpha',
        'latitude': 36.2118763,
        'longitude': 37.1163095,
        'isAccessible': true,
        'signalStrength': 82,
        'status': 'active',
        'networkType': '4G LTE',
        'pingLatency': 26,
        'uploadSpeed': 16.2,
        'downloadSpeed': 46.5,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      return handler.resolve(
        Response(requestOptions: options, statusCode: 200, data: towerData),
      );
    }

    return handler.next(options);
  }

  /// Generate realistic mock tower data around a location
  List<Map<String, dynamic>> _generateMockTowers(
    double centerLat,
    double centerLon,
    int count,
  ) {
    final towers = <Map<String, dynamic>>[];
    final networkTypes = ['4G LTE', '5G', '4G', '3G'];
    final statuses = ['active', 'active', 'active', 'maintenance'];

    for (int i = 0; i < count; i++) {
      // Generate random position within ~5km radius
      final angle = _random.nextDouble() * 2 * pi;
      final distance = _random.nextDouble() * 0.05; // ~5km
      final lat = centerLat + (distance * cos(angle));
      final lon = centerLon + (distance * sin(angle));

      final status = statuses[_random.nextInt(statuses.length)];
      final isActive = status == 'active';
      final networkType = networkTypes[_random.nextInt(networkTypes.length)];
      final signalStrength = isActive ? 60 + _random.nextInt(40) : 30 + _random.nextInt(30);

      towers.add({
        'id': (i + 1).toString(),
        'name': 'Cell Tower ${String.fromCharCode(65 + i)}',
        'latitude': lat,
        'longitude': lon,
        'isAccessible': isActive,
        'signalStrength': signalStrength,
        'status': status,
        'networkType': networkType,
        'pingLatency': isActive ? 15 + _random.nextInt(35) : 50 + _random.nextInt(50),
        'uploadSpeed': isActive ? 10.0 + _random.nextDouble() * 30 : 2.0 + _random.nextDouble() * 8,
        'downloadSpeed': isActive ? 30.0 + _random.nextDouble() * 70 : 10.0 + _random.nextDouble() * 20,
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    }

    return towers;
  }
}
