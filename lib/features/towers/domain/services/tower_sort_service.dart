import 'package:shared_preferences/shared_preferences.dart';
import 'package:network_app/features/towers/domain/entities/cellular_tower.dart';

import 'dart:math';

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
        sorted.sort((a, b) => (b.signalStrength).compareTo(a.signalStrength));
        break;

      case SortOption.newest:
        // Assuming newest means highest signal
        sorted.sort((a, b) => b.signalStrength.compareTo(a.signalStrength));
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
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) *
            cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p)) /
            2;
    const earthRadius = 6371; // Radius in km
    return earthRadius * 2 * asin(sqrt(a));
  }

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
