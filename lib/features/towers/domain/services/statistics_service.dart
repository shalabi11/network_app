import 'package:network_app/features/towers/domain/entities/cellular_tower.dart';

/// Tower statistics model
class TowerStatistics {
  final int totalTowers;
  final double averageSignal;
  final int strongestSignal;
  final int weakestSignal;
  final Map<String, int> towersPerNetwork; // MNC to count
  final Map<String, int> towersPerType; // Radio type to count
  final double averageDistance;
  final int nearestDistance;
  final int farthestDistance;

  TowerStatistics({
    required this.totalTowers,
    required this.averageSignal,
    required this.strongestSignal,
    required this.weakestSignal,
    required this.towersPerNetwork,
    required this.towersPerType,
    required this.averageDistance,
    required this.nearestDistance,
    required this.farthestDistance,
  });
}

/// Service for calculating tower statistics
class StatisticsService {
  /// Calculate statistics for a list of towers
  TowerStatistics calculateStatistics(
    List<CellularTower> towers, {
    double? userLatitude,
    double? userLongitude,
  }) {
    if (towers.isEmpty) {
      return TowerStatistics(
        totalTowers: 0,
        averageSignal: 0,
        strongestSignal: 0,
        weakestSignal: 0,
        towersPerNetwork: {},
        towersPerType: {},
        averageDistance: 0,
        nearestDistance: 0,
        farthestDistance: 0,
      );
    }

    // Signal statistics
    final signals = towers
        .map((t) => t.signalStrength ?? 0)
        .where((s) => s != 0)
        .toList();
    final avgSignal = signals.isEmpty ? 0.0 : signals.reduce((a, b) => a + b) / signals.length;
    final strongest = signals.isEmpty ? 0 : signals.reduce((a, b) => a > b ? a : b);
    final weakest = signals.isEmpty ? 0 : signals.reduce((a, b) => a < b ? a : b);

    // Network type statistics
    final networkMap = <String, int>{};
    for (var tower in towers) {
      final key = 'MNC ${tower.mnc}';
      networkMap[key] = (networkMap[key] ?? 0) + 1;
    }

    // Radio type statistics
    final typeMap = <String, int>{};
    for (var tower in towers) {
      final type = tower.type ?? 'Unknown';
      typeMap[type] = (typeMap[type] ?? 0) + 1;
    }

    // Distance statistics
    List<int> distances = [];
    if (userLatitude != null && userLongitude != null) {
      distances = towers
          .map((t) => _calculateDistance(
                userLatitude,
                userLongitude,
                t.latitude,
                t.longitude,
              ).toInt())
          .toList();
    }

    return TowerStatistics(
      totalTowers: towers.length,
      averageSignal: avgSignal,
      strongestSignal: strongest,
      weakestSignal: weakest,
      towersPerNetwork: networkMap,
      towersPerType: typeMap,
      averageDistance: distances.isEmpty ? 0 : distances.reduce((a, b) => a + b) / distances.length,
      nearestDistance: distances.isEmpty ? 0 : distances.reduce((a, b) => a < b ? a : b),
      farthestDistance: distances.isEmpty ? 0 : distances.reduce((a, b) => a > b ? a : b),
    );
  }

  /// Calculate distance between two coordinates
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        (lat2 - lat1) * p / 2 * (lat2 - lat1) * p / 2.cos() +
        (lon2 - lon1) * p / 2 * (lon2 - lon1) * p / 2.cos() * (lat1 * p).cos() * (lat2 * p).cos();
    return 12742 * (a.asin()); // 2 * R; R = 6371 km
  }
}
