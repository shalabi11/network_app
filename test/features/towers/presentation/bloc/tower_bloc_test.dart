import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:network_app/core/error/failures.dart';
import 'package:network_app/features/towers/domain/entities/cellular_tower.dart';
import 'package:network_app/features/towers/domain/repositories/tower_repository.dart';
import 'package:network_app/features/towers/domain/usecases/get_nearby_towers.dart';
import 'package:network_app/features/towers/domain/usecases/ping_tower.dart';
import 'package:network_app/features/towers/presentation/bloc/tower_bloc.dart';
import 'package:network_app/features/towers/presentation/bloc/tower_event.dart';
import 'package:network_app/features/towers/presentation/bloc/tower_state.dart';

@GenerateMocks([GetNearbyTowers, PingTower, TowerRepository])
import 'tower_bloc_test.mocks.dart';

void main() {
  late TowerBloc bloc;
  late MockGetNearbyTowers mockGetNearbyTowers;
  late MockPingTower mockPingTower;
  late MockTowerRepository mockTowerRepository;

  setUp(() {
    mockGetNearbyTowers = MockGetNearbyTowers();
    mockPingTower = MockPingTower();
    mockTowerRepository = MockTowerRepository();
    bloc = TowerBloc(
      getNearbyTowers: mockGetNearbyTowers,
      pingTower: mockPingTower,
      towerRepository: mockTowerRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const testLatitude = 31.5;
  const testLongitude = 34.5;

  final testTowers = [
    const CellularTower(
      id: '1',
      name: 'Tower 1',
      latitude: 31.5,
      longitude: 34.5,
      isAccessible: true,
      signalStrength: -60,
      status: 'online',
    ),
  ];

  group('LoadNearbyTowers', () {
    test('initial state should be TowerInitial', () {
      expect(bloc.state, TowerInitial());
    });

    blocTest<TowerBloc, TowerState>(
      'should emit [TowerLoading, TowerLoaded] when data is gotten successfully',
      build: () {
        when(
          mockGetNearbyTowers(any),
        ).thenAnswer((_) async => Right(testTowers));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const LoadNearbyTowers(
          latitude: testLatitude,
          longitude: testLongitude,
        ),
      ),
      expect: () => [
        TowerLoading(),
        TowerLoaded(
          towers: testTowers,
          userLatitude: testLatitude,
          userLongitude: testLongitude,
        ),
      ],
    );

    blocTest<TowerBloc, TowerState>(
      'should emit [TowerLoading, TowerError] when getting data fails',
      build: () {
        when(
          mockGetNearbyTowers(any),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const LoadNearbyTowers(
          latitude: testLatitude,
          longitude: testLongitude,
        ),
      ),
      expect: () => [
        TowerLoading(),
        const TowerError('No internet connection'),
      ],
    );
  });

  group('PingTowerEvent', () {
    const testTowerId = '1';
    const testLatency = 50;

    blocTest<TowerBloc, TowerState>(
      'should emit [TowerPinging, TowerPinged] when ping is successful',
      build: () {
        when(
          mockPingTower(any),
        ).thenAnswer((_) async => const Right(testLatency));
        return bloc;
      },
      act: (bloc) => bloc.add(const PingTowerEvent(testTowerId)),
      expect: () => [
        const TowerPinging(testTowerId),
        TowerPinged(
          towerId: testTowerId,
          latency: testLatency,
          towers: testTowers,
        ),
      ],
    );

    blocTest<TowerBloc, TowerState>(
      'should emit [TowerPinging, TowerError] when ping fails',
      build: () {
        when(
          mockPingTower(any),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const PingTowerEvent(testTowerId)),
      expect: () => [
        const TowerPinging(testTowerId),
        const TowerError('No internet connection'),
      ],
    );
  });
}
