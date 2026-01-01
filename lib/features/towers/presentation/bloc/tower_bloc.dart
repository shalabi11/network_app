import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/get_nearby_towers.dart';
import '../../domain/usecases/ping_tower.dart';
import '../../../towers/domain/repositories/tower_repository.dart';
import 'tower_event.dart';
import 'tower_state.dart';

class TowerBloc extends Bloc<TowerEvent, TowerState> {
  final GetNearbyTowers getNearbyTowers;
  final PingTower pingTower;
  final TowerRepository towerRepository;

  TowerBloc({
    required this.getNearbyTowers,
    required this.pingTower,
    required this.towerRepository,
  }) : super(TowerInitial()) {
    on<LoadNearbyTowers>(_onLoadNearbyTowers);
    on<PingTowerEvent>(_onPingTower);
    on<RefreshTowers>(_onRefreshTowers);
    on<LoadCachedTowers>(_onLoadCachedTowers);
  }

  Future<void> _onLoadNearbyTowers(
    LoadNearbyTowers event,
    Emitter<TowerState> emit,
  ) async {
    emit(TowerLoading());

    final result = await getNearbyTowers(
      GetNearbyTowersParams(
        latitude: event.latitude,
        longitude: event.longitude,
        radiusKm: event.radiusKm,
      ),
    );

    result.fold(
      (failure) {
        AppLogger.error('Failed to load nearby towers: ${failure.message}');
        emit(TowerError(failure.message));
      },
      (towers) {
        AppLogger.info('Loaded ${towers.length} towers');
        emit(
          TowerLoaded(
            towers: towers,
            userLatitude: event.latitude,
            userLongitude: event.longitude,
          ),
        );
      },
    );
  }

  Future<void> _onPingTower(
    PingTowerEvent event,
    Emitter<TowerState> emit,
  ) async {
    // Keep current towers if available
    List<CellularTower> currentTowers = [];
    double? userLat;
    double? userLon;
    
    if (state is TowerLoaded) {
      currentTowers = (state as TowerLoaded).towers;
      userLat = (state as TowerLoaded).userLatitude;
      userLon = (state as TowerLoaded).userLongitude;
    }

    emit(TowerPinging(event.towerId));

    final result = await pingTower(PingTowerParams(towerId: event.towerId));

    result.fold(
      (failure) {
        AppLogger.error('Failed to ping tower: ${failure.message}');
        if (currentTowers.isNotEmpty) {
          // Return to loaded state with towers
          emit(TowerLoaded(
            towers: currentTowers,
            userLatitude: userLat,
            userLongitude: userLon,
          ));
        } else {
          emit(TowerError(failure.message));
        }
      },
      (latency) {
        AppLogger.info('Tower pinged successfully: ${latency}ms');
        emit(TowerPinged(
          towerId: event.towerId,
          latency: latency,
          towers: currentTowers,
          userLatitude: userLat,
          userLongitude: userLon,
        ));
      },
    );
  }

  Future<void> _onRefreshTowers(
    RefreshTowers event,
    Emitter<TowerState> emit,
  ) async {
    // Don't show loading state for refresh
    final result = await getNearbyTowers(
      GetNearbyTowersParams(
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    );

    result.fold(
      (failure) => emit(TowerError(failure.message)),
      (towers) => emit(
        TowerLoaded(
          towers: towers,
          userLatitude: event.latitude,
          userLongitude: event.longitude,
        ),
      ),
    );
  }

  Future<void> _onLoadCachedTowers(
    LoadCachedTowers event,
    Emitter<TowerState> emit,
  ) async {
    emit(TowerLoading());

    final result = await towerRepository.getCachedTowers();

    result.fold((failure) => emit(TowerError(failure.message)), (towers) {
      if (towers.isEmpty) {
        emit(const TowerError('No cached towers available'));
      } else {
        emit(TowerLoaded(towers: towers));
      }
    });
  }
}
