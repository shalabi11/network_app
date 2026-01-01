import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/cellular_tower.dart';
import '../../domain/repositories/tower_repository.dart';
import '../datasources/tower_local_data_source.dart';
import '../datasources/tower_remote_data_source.dart';

class TowerRepositoryImpl implements TowerRepository {
  final TowerRemoteDataSource remoteDataSource;
  final TowerLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  TowerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<CellularTower>>> getNearbyTowers({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final towers = await remoteDataSource.getNearbyTowers(
          latitude: latitude,
          longitude: longitude,
          radiusKm: radiusKm,
        );
        await localDataSource.cacheTowers(towers);
        return Right(towers.map((model) => model.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error occurred'));
      }
    } else {
      try {
        final towers = await localDataSource.getCachedTowers();
        if (towers.isEmpty) {
          return const Left(NetworkFailure('No cached data available'));
        }
        return Right(towers.map((model) => model.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
  
  @override
  Future<Either<Failure, CellularTower>> getTowerById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final tower = await remoteDataSource.getTowerById(id);
        return Right(tower.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      try {
        final tower = await localDataSource.getCachedTowerById(id);
        if (tower != null) {
          return Right(tower.toEntity());
        }
        return const Left(CacheFailure('Tower not found in cache'));
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
  
  @override
  Future<Either<Failure, int>> pingTower(String towerId) async {
    if (await networkInfo.isConnected) {
      try {
        final latency = await remoteDataSource.pingTower(towerId);
        return Right(latency);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, CellularTower>> updateTowerStats(String towerId) async {
    if (await networkInfo.isConnected) {
      try {
        final tower = await remoteDataSource.updateTowerStats(towerId);
        return Right(tower.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<CellularTower>>> getCachedTowers() async {
    try {
      final towers = await localDataSource.getCachedTowers();
      return Right(towers.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
