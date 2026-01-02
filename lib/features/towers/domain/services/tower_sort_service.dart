import 'package:shared_preferences/shared_preferences.dart';
import 'package:network_app/features/towers/domain/entities/cellular_tower.dart';

enum SortOption {
  name,
  distance,
  signal,
  newest,
}

/// Service for managing tower sorting and filtering
class TowerSortService {
  final SharedPreferences prefs;
  static const String _favoritesKey = 'favorite_towers';

  TowerSortService(this.prefs);

  /// Sort towers based on the selected option
  List<CellularTower> sortTowers(
    List<CellularTower> towers,
    SortOption option, {
    double? userLatitude,
    double? userLongitude,
  }) {
    final sorted = List<CellularTower>.from(towers);

    switch (option) {
      case SortOption.name:
        sorted.sort((a, b) => a.id.compareTo(b.id));
        break;

      case SortOption.distance:
        if (userLatitude != null && userLongitude != null) {
          sorted.sort((a, b) {
            final distanceA = _calculateDistance(
              userLatitude,
              userLongitude,
              a.latitude,
              a.longitude,
            );
            final distanceB = _calculateDistance(
              userLatitude,
              userLongitude,
              b.latitude,
              b.longitude,
            );
            return distanceA.compareTo(distanceB);
          });
        }
        break;

      case SortOption.signal:
        sorted.sort((a, b) => (b.signalStrength ?? 0).compareTo(a.signalStrength ?? 0));
        break;

      case SortOption.newest:
        // Assuming newest means highest cellId
        sorted.sort((a, b) => b.cellId.compareTo(a.cellId));
        break;
    }

    return sorted;
  }

  /// Calculate distance between two coordinates using Haversine formula
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371; // Radius in km
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);

    final a = (1 - (dLat / (2 * 3.14159)).cos()) / 2 +
        (dLat / (2 * 3.14159)).cos() *
            (dLon / (2 * 3.14159)).cos() *
            (1 - ((lon2 - lon1) / (2 * 3.14159)).cos()) /
            2;

    final c = 2 * (a.asin());
    return earthRadius * c;
  }

  double _toRad(double degree) => degree * 3.14159 / 180;

  /// Add tower to favorites
  Future<void> addFavorite(String towerId) async {
    final favorites = getFavorites();
    if (!favorites.contains(towerId)) {
      favorites.add(towerId);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  /// Remove tower from favorites
  Future<void> removeFavorite(String towerId) async {
    final favorites = getFavorites();
    favorites.remove(towerId);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  /// Get all favorite tower IDs
  List<String> getFavorites() {
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  /// Check if tower is favorite
  bool isFavorite(String towerId) {
    return getFavorites().contains(towerId);
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String towerId) async {
    if (isFavorite(towerId)) {
      await removeFavorite(towerId);
    } else {
      await addFavorite(towerId);
    }
  }
}
