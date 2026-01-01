import 'package:dio/dio.dart';
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
      final response = await dio.get(
        '/towers/nearby',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radiusKm,
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> towersJson = response.data['towers'];
        return towersJson
            .map((json) => CellularTowerModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Failed to fetch nearby towers');
      }
    } on DioException catch (e) {
      AppLogger.error('Error fetching nearby towers', e);
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
  
  @override
  Future<CellularTowerModel> getTowerById(String id) async {
    try {
      final response = await dio.get('/towers/$id');
      
      if (response.statusCode == 200) {
        return CellularTowerModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch tower details');
      }
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
      final response = await dio.post('/towers/$towerId/ping');
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
      final response = await dio.put('/towers/$towerId/stats');
      
      if (response.statusCode == 200) {
        return CellularTowerModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to update tower stats');
      }
    } on DioException catch (e) {
      AppLogger.error('Error updating tower stats', e);
      throw NetworkException(e.message ?? 'Network error');
    } catch (e) {
      AppLogger.error('Unexpected error updating tower stats', e);
      throw ServerException('Unexpected error occurred');
    }
  }
}
