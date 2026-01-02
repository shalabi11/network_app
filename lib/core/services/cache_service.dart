import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Cache management service for storing and retrieving data locally
class CacheService {
  static const String _towersKey = 'cached_towers';
  static const String _towersTimestampKey = 'cached_towers_timestamp';
  static const int _cacheExpirationMinutes = 30; // Cache expires after 30 minutes

  final SharedPreferences _prefs;

  CacheService(this._prefs);

  /// Save towers data to cache
  Future<void> cacheTowers(String jsonData) async {
    try {
      await _prefs.setString(_towersKey, jsonData);
      await _prefs.setInt(
        _towersTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      // Silently fail if caching doesn't work
      print('Cache error: $e');
    }
  }

  /// Get towers data from cache if not expired
  String? getCachedTowers() {
    try {
      final cachedData = _prefs.getString(_towersKey);
      final timestamp = _prefs.getInt(_towersTimestampKey);

      if (cachedData == null || timestamp == null) {
        return null;
      }

      // Check if cache is expired
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      final expirationMs = _cacheExpirationMinutes * 60 * 1000;

      if (cacheAge > expirationMs) {
        // Clear expired cache
        clearCache();
        return null;
      }

      return cachedData;
    } catch (e) {
      // Silently fail if cache retrieval doesn't work
      print('Cache retrieval error: $e');
      return null;
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    try {
      await _prefs.remove(_towersKey);
      await _prefs.remove(_towersTimestampKey);
    } catch (e) {
      print('Cache clear error: $e');
    }
  }

  /// Check if cache is valid (not expired)
  bool isCacheValid() {
    try {
      final timestamp = _prefs.getInt(_towersTimestampKey);
      if (timestamp == null) return false;

      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      final expirationMs = _cacheExpirationMinutes * 60 * 1000;

      return cacheAge <= expirationMs;
    } catch (e) {
      return false;
    }
  }
}
