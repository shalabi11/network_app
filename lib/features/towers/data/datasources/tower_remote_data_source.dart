import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/cellular_tower_model.dart';

abstract class TowerRemoteDataSource {
  Future<List<CellularTowerModel>> getNearbyTowers({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  });

  Future<CellularTowerModel> getTowerById(String id);

  Future<int> pingTower(String towerId);

  Future<CellularTowerModel> updateTowerStats(String towerId);
}

class TowerRemoteDataSourceImpl implements TowerRemoteDataSource {
  final Dio dio;

  TowerRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CellularTowerModel>> getNearbyTowers({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      // OpenCelliD API call to get nearby towers
      final response = await dio.get(
        AppConstants.cellTowerEndpoint,
        queryParameters: {
          'key': AppConstants.openCellIdApiKey,
          'lat': latitude,
          'lon': longitude,
          'format': 'json',
          'limit': 20, // Number of nearby towers to fetch
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // OpenCelliD returns a single tower or array
        if (data is List) {
          return data
              .map((json) => _convertOpenCellIdToModel(json, latitude, longitude))
              .toList();
        } else if (data is Map<String, dynamic>) {
          return [_convertOpenCellIdToModel(data, latitude, longitude)];
        } else {
          // If no data, return empty list
          return [];
        }
      } else {
        throw ServerException('Failed to fetch nearby towers');
      }
    } on DioException catch (e) {
      AppLogger.error('Error fetching nearby towers from OpenCelliD', e);
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException(e.message ?? 'Server error');
      }
    } catch (e) {
      AppLogger.error('Unexpected error fetching nearby towers', e);
      throw ServerException('Unexpected error occurred');
    }
  }

  /// Convert OpenCelliD API response to our model
  CellularTowerModel _convertOpenCellIdToModel(
    Map<String, dynamic> data,
    double userLat,
    double userLon,
  ) {
    // OpenCelliD response format
    final lat = (data['lat'] ?? userLat).toDouble();
    final lon = (data['lon'] ?? userLon).toDouble();
    final cellId = data['cellid']?.toString() ?? data['cell']?.toString() ?? 'unknown';
    final mcc = data['mcc']?.toString() ?? '';
    final mnc = data['mnc']?.toString() ?? '';
    final lac = data['lac']?.toString() ?? '';
    final range = data['range']?.toInt() ?? 1000;
    
    // Determine network type from radio field
    String networkType = '4G LTE';
    if (data['radio'] != null) {
      final radio = data['radio'].toString().toUpperCase();
      if (radio.contains('LTE')) {
        networkType = '4G LTE';
      } else if (radio.contains('NR') || radio.contains('5G')) {
        networkType = '5G';
      } else if (radio.contains('UMTS') || radio.contains('WCDMA')) {
        networkType = '3G';
      } else if (radio.contains('GSM')) {
        networkType = '2G';
      }
    }

    // Calculate approximate signal strength based on range
    int signalStrength = 100 - ((range / 100).clamp(0, 70).toInt());
    
    return CellularTowerModel(
      id: '$mcc-$mnc-$lac-$cellId',
      name: 'Cell Tower $cellId',
      latitude: lat,
      longitude: lon,
      isAccessible: true,
      signalStrength: signalStrength,
      status: 'active',
      networkType: networkType,
      pingLatency: (20 + (range / 50)).toInt(),
      uploadSpeed: (15.0 + (signalStrength / 5)).toDouble(),
      downloadSpeed: (30.0 + (signalStrength / 2)).toDouble(),
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<CellularTowerModel> getTowerById(String id) async {
    try {
      // OpenCelliD doesn't support direct ID lookup
      // We return a simplified version or throw unimplemented
      throw UnimplementedError('Tower by ID lookup not supported by OpenCelliD API');
    } on DioException catch (e) {
      AppLogger.error('Error fetching tower by id', e);
      throw NetworkException(e.message ?? 'Network error');
    } catch (e) {
      AppLogger.error('Unexpected error fetching tower', e);
      throw ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<int> pingTower(String towerId) async {
    try {
      final startTime = DateTime.now();
      
      // Simulate a real ping by making a lightweight request
      // You can ping the actual tower location if available
      final response = await dio.get(
        AppConstants.cellTowerEndpoint,
        queryParameters: {
          'key': AppConstants.openCellIdApiKey,
          'format': 'json',
        },
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      
      final endTime = DateTime.now();

      if (response.statusCode == 200) {
        return endTime.difference(startTime).inMilliseconds;
      } else {
        throw ServerException('Failed to ping tower');
      }
    } on DioException catch (e) {
      AppLogger.error('Error pinging tower', e);
      throw NetworkException(e.message ?? 'Network error');
    } catch (e) {
      AppLogger.error('Unexpected error pinging tower', e);
      throw ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<CellularTowerModel> updateTowerStats(String towerId) async {
    try {
      // For OpenCelliD, we would fetch updated data for the tower
      // Since we don't have a direct tower ID query, return the tower data as-is
      // In a real scenario, you'd query by cell ID components
      throw UnimplementedError('Tower stats update not supported by OpenCelliD API');
    } on DioException catch (e) {
      AppLogger.error('Error updating tower stats', e);
      throw NetworkException(e.message ?? 'Network error');
    } catch (e) {
      AppLogger.error('Unexpected error updating tower stats', e);
      throw ServerException('Unexpected error occurred');
    }
  }
}
