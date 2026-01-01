import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/tower_repository.dart';

class PingTower implements UseCase<int, PingTowerParams> {
  final TowerRepository repository;
  
  PingTower(this.repository);
  
  @override
  Future<Either<Failure, int>> call(PingTowerParams params) async {
    return await repository.pingTower(params.towerId);
  }
}

class PingTowerParams {
  final String towerId;
  
  PingTowerParams({required this.towerId});
}
