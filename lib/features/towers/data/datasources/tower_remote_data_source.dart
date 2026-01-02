import 'dart:math';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/services/cell_info_service.dart';
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
  final Random _random = Random();

  TowerRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CellularTowerModel>> getNearbyTowers({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      // Try OpenCelliD API first using getInArea endpoint
      if (!AppConstants.useMockData) {
        try {
          // Calculate bounding box: approximately ±0.1 degrees (~11km)
          final latMin = latitude - 0.1;
          final latMax = latitude + 0.1;
          final lonMin = longitude - 0.1;
          final lonMax = longitude + 0.1;

          final response = await dio.get(
            AppConstants.cellTowerEndpoint,
            queryParameters: {
              'key': AppConstants.openCellIdApiKey,
              'BBOX': '$latMin,$lonMin,$latMax,$lonMax',
              'mcc': AppConstants.countryMCC, // Germany (262)
              'format': 'json',
              'limit': 20,
              'offset': 0,
            },
            options: Options(
              // connectTimeout: const Duration(seconds: 60),
              sendTimeout: const Duration(seconds: 60),
              receiveTimeout: const Duration(seconds: 60),
            ),
          );

          if (response.statusCode == 200) {
            final data = response.data;

            // getInArea returns {"count": n, "cells": [...]}
            if (data is Map<String, dynamic> && data.containsKey('cells')) {
              final cells = data['cells'] as List;
              if (cells.isNotEmpty) {
                AppLogger.info(
                  'OpenCelliD returned ${cells.length} towers in Germany (MCC 262)',
                );

                // Get connected cell info to mark the connected tower
                final connectedCell = await CellInfoService.getConnectedCell();
                final connectedTowerId = connectedCell?.towerId;

                if (connectedTowerId != null) {
                  AppLogger.info(
                    'Currently connected to tower: $connectedTowerId',
                  );
                }

                return cells
                    .map(
                      (json) => _convertOpenCellIdToModel(
                        json,
                        latitude,
                        longitude,
                        connectedTowerId,
                      ),
                    )
                    .toList();
              }
            }
          }
        } on DioException catch (e) {
          AppLogger.error(
            'OpenCelliD API failed, falling back to mock data',
            e,
          );
          // Fall through to mock data generation
        }
      }

      // Generate mock data as fallback
      AppLogger.info('Using mock data for nearby towers');
      return _generateMockTowers(latitude, longitude, 8);
    } catch (e) {
      AppLogger.error('Unexpected error fetching nearby towers', e);
      // Return mock data even on unexpected errors
      return _generateMockTowers(latitude, longitude, 8);
    }
  }

  /// Convert OpenCelliD API response to our model
  CellularTowerModel _convertOpenCellIdToModel(
    Map<String, dynamic> data,
    double userLat,
    double userLon,
    String? connectedTowerId,
  ) {
    // OpenCelliD response format
    final lat = (data['lat'] ?? userLat).toDouble();
    final lon = (data['lon'] ?? userLon).toDouble();
    final cellId =
        data['cellid']?.toString() ?? data['cell']?.toString() ?? 'unknown';
    final mcc = data['mcc']?.toString() ?? '';
    final mnc = data['mnc']?.toString() ?? '';
    final lac = data['lac']?.toString() ?? '';
    final range = data['range']?.toInt() ?? 1000;

    // Generate tower ID
    final towerId = '$mcc-$mnc-$lac-$cellId';
    final isConnected = connectedTowerId != null && towerId == connectedTowerId;

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
    int signalStrength = (100 - ((range / 100).clamp(0, 70))).toInt();

    return CellularTowerModel(
      id: towerId,
      name: isConnected ? 'Connected Tower $cellId' : 'Cell Tower $cellId',
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
      isConnected: isConnected,
    );
  }

  @override
  Future<CellularTowerModel> getTowerById(String id) async {
    try {
      // OpenCelliD doesn't support direct ID lookup
      // We return a simplified version or throw unimplemented
      throw UnimplementedError(
        'Tower by ID lookup not supported by OpenCelliD API',
      );
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

      // Try real API ping
      if (!AppConstants.useMockData) {
        try {
          final response = await dio.get(
            AppConstants.cellTowerEndpoint,
            queryParameters: {
              'key': AppConstants.openCellIdApiKey,
              'format': 'json',
            },
            options: Options(
              sendTimeout: const Duration(seconds: 3),
              receiveTimeout: const Duration(seconds: 3),
            ),
          );

          final endTime = DateTime.now();

          if (response.statusCode == 200) {
            return endTime.difference(startTime).inMilliseconds;
          }
        } on DioException catch (e) {
          AppLogger.info('API ping failed, using simulated ping');
          AppLogger.debug('Ping error: ${e.message}');
          // Fall through to mock ping
        }
      }

      // Simulate ping with random latency
      await Future.delayed(Duration(milliseconds: 50 + _random.nextInt(150)));
      return 15 + _random.nextInt(50);
    } catch (e) {
      AppLogger.error('Unexpected error pinging tower', e);
      // Return simulated ping even on error
      return 25 + _random.nextInt(40);
    }
  }

  @override
  Future<CellularTowerModel> updateTowerStats(String towerId) async {
    try {
      // For OpenCelliD, we would fetch updated data for the tower
      // Since we don't have a direct tower ID query, return the tower data as-is
      // In a real scenario, you'd query by cell ID components
      throw UnimplementedError(
        'Tower stats update not supported by OpenCelliD API',
      );
    } on DioException catch (e) {
      AppLogger.error('Error updating tower stats', e);
      throw NetworkException(e.message ?? 'Network error');
    } catch (e) {
      AppLogger.error('Unexpected error updating tower stats', e);
      throw ServerException('Unexpected error occurred');
    }
  }

  /// Generate realistic mock tower data around a location
  List<CellularTowerModel> _generateMockTowers(
    double centerLat,
    double centerLon,
    int count,
  ) {
    final towers = <CellularTowerModel>[];
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
      final signalStrength = isActive
          ? 60 + _random.nextInt(40)
          : 30 + _random.nextInt(30);

      towers.add(
        CellularTowerModel(
          id: (i + 1).toString(),
          name: 'Cell Tower ${String.fromCharCode(65 + i)}',
          latitude: lat,
          longitude: lon,
          isAccessible: isActive,
          signalStrength: signalStrength,
          status: status,
          networkType: networkType,
          pingLatency: isActive
              ? 15 + _random.nextInt(35)
              : 50 + _random.nextInt(50),
          uploadSpeed: isActive
              ? 10.0 + _random.nextDouble() * 30
              : 2.0 + _random.nextDouble() * 8,
          downloadSpeed: isActive
              ? 30.0 + _random.nextDouble() * 70
              : 10.0 + _random.nextDouble() * 20,
          lastUpdated: DateTime.now(),
        ),
      );
    }

    return towers;
  }
}
