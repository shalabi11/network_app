import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/cellular_tower_model.dart';

abstract class TowerLocalDataSource {
  Future<List<CellularTowerModel>> getCachedTowers();
  Future<void> cacheTowers(List<CellularTowerModel> towers);
  Future<CellularTowerModel?> getCachedTowerById(String id);
  Future<void> clearCache();
}

class TowerLocalDataSourceImpl implements TowerLocalDataSource {
  static const String towersBoxName = 'towers';
  
  @override
  Future<List<CellularTowerModel>> getCachedTowers() async {
    try {
      final box = await Hive.openBox<Map>(towersBoxName);
      final towers = box.values
          .map((json) => CellularTowerModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      return towers;
    } catch (e) {
      AppLogger.error('Error getting cached towers', e);
      throw CacheException('Failed to get cached towers');
    }
  }
  
  @override
  Future<void> cacheTowers(List<CellularTowerModel> towers) async {
    try {
      final box = await Hive.openBox<Map>(towersBoxName);
      await box.clear();
      for (var tower in towers) {
        await box.put(tower.id, tower.toJson());
      }
    } catch (e) {
      AppLogger.error('Error caching towers', e);
      throw CacheException('Failed to cache towers');
    }
  }
  
  @override
  Future<CellularTowerModel?> getCachedTowerById(String id) async {
    try {
      final box = await Hive.openBox<Map>(towersBoxName);
      final json = box.get(id);
      if (json != null) {
        return CellularTowerModel.fromJson(Map<String, dynamic>.from(json));
      }
      return null;
    } catch (e) {
      AppLogger.error('Error getting cached tower by id', e);
      throw CacheException('Failed to get cached tower');
    }
  }
  
  @override
  Future<void> clearCache() async {
    try {
      final box = await Hive.openBox<Map>(towersBoxName);
      await box.clear();
    } catch (e) {
      AppLogger.error('Error clearing cache', e);
      throw CacheException('Failed to clear cache');
    }
  }
}
