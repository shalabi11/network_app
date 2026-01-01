import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cellular_tower.dart';
import '../repositories/tower_repository.dart';

class GetNearbyTowers
    implements UseCase<List<CellularTower>, GetNearbyTowersParams> {
  final TowerRepository repository;

  GetNearbyTowers(this.repository);

  @override
  Future<Either<Failure, List<CellularTower>>> call(
    GetNearbyTowersParams params,
  ) async {
    return await repository.getNearbyTowers(
      latitude: params.latitude,
      longitude: params.longitude,
      radiusKm: params.radiusKm,
    );
  }
}

class GetNearbyTowersParams {
  final double latitude;
  final double longitude;
  final double radiusKm;

  GetNearbyTowersParams({
    required this.latitude,
    required this.longitude,
    this.radiusKm = 10.0,
  });
}
