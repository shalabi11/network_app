import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:network_app/core/error/failures.dart';
import 'package:network_app/features/towers/domain/entities/cellular_tower.dart';
import 'package:network_app/features/towers/domain/repositories/tower_repository.dart';
import 'package:network_app/features/towers/domain/usecases/get_nearby_towers.dart';

@GenerateMocks([TowerRepository])
import 'get_nearby_towers_test.mocks.dart';

void main() {
  late GetNearbyTowers usecase;
  late MockTowerRepository mockTowerRepository;

  setUp(() {
    mockTowerRepository = MockTowerRepository();
    usecase = GetNearbyTowers(mockTowerRepository);
  });

  const testLatitude = 31.5;
  const testLongitude = 34.5;
  const testRadiusKm = 10.0;

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
    const CellularTower(
      id: '2',
      name: 'Tower 2',
      latitude: 31.51,
      longitude: 34.51,
      isAccessible: false,
      signalStrength: -80,
      status: 'offline',
    ),
  ];

  test('should get nearby towers from the repository', () async {
    // arrange
    when(
      mockTowerRepository.getNearbyTowers(
        latitude: anyNamed('latitude'),
        longitude: anyNamed('longitude'),
        radiusKm: anyNamed('radiusKm'),
      ),
    ).thenAnswer((_) async => Right(testTowers));

    // act
    final result = await usecase(
      GetNearbyTowersParams(
        latitude: testLatitude,
        longitude: testLongitude,
        radiusKm: testRadiusKm,
      ),
    );

    // assert
    expect(result, Right(testTowers));
    verify(
      mockTowerRepository.getNearbyTowers(
        latitude: testLatitude,
        longitude: testLongitude,
        radiusKm: testRadiusKm,
      ),
    );
    verifyNoMoreInteractions(mockTowerRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    const testFailure = NetworkFailure('No internet connection');
    when(
      mockTowerRepository.getNearbyTowers(
        latitude: anyNamed('latitude'),
        longitude: anyNamed('longitude'),
        radiusKm: anyNamed('radiusKm'),
      ),
    ).thenAnswer((_) async => const Left(testFailure));

    // act
    final result = await usecase(
      GetNearbyTowersParams(
        latitude: testLatitude,
        longitude: testLongitude,
        radiusKm: testRadiusKm,
      ),
    );

    // assert
    expect(result, const Left(testFailure));
    verify(
      mockTowerRepository.getNearbyTowers(
        latitude: testLatitude,
        longitude: testLongitude,
        radiusKm: testRadiusKm,
      ),
    );
    verifyNoMoreInteractions(mockTowerRepository);
  });
}
