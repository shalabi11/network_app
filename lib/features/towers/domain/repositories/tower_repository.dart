import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cellular_tower.dart';

abstract class TowerRepository {
  Future<Either<Failure, List<CellularTower>>> getNearbyTowers({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  });
  
  Future<Either<Failure, CellularTower>> getTowerById(String id);
  
  Future<Either<Failure, int>> pingTower(String towerId);
  
  Future<Either<Failure, CellularTower>> updateTowerStats(String towerId);
  
  Future<Either<Failure, List<CellularTower>>> getCachedTowers();
}
