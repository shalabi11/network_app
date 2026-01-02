import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:network_app/features/towers/domain/entities/cellular_tower.dart';

/// Service for managing offline data and sync status
class OfflineSyncService {
  final SharedPreferences prefs;
  
  static const String _offlineDataKey = 'offline_tower_data';
  static const String _lastSyncKey = 'last_sync_time';
  static const String _pendingChangesKey = 'pending_changes';
  static const int _maxOfflineDataRetentionDays = 7;

  OfflineSyncService(this.prefs);

  /// Save data for offline use
  Future<void> saveOfflineData(List<CellularTower> towers) async {
    try {
      final jsonData = jsonEncode(
        towers.map((t) => {
          'id': t.id,
          'name': t.name,
          'latitude': t.latitude,
          'longitude': t.longitude,
          'signalStrength': t.signalStrength,
          'status': t.status,
          'networkType': t.networkType,
          'operatorName': t.operatorName,
        }).toList(),
      );
      await prefs.setString(_offlineDataKey, jsonData);
      await prefs.setInt(
        _lastSyncKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      print('Error saving offline data: $e');
    }
  }

  /// Get offline data
  List<Map<String, dynamic>> getOfflineData() {
    try {
      final jsonString = prefs.getString(_offlineDataKey);
      if (jsonString == null) return [];
      
      final List<dynamic> decoded = jsonDecode(jsonString);
      return List<Map<String, dynamic>>.from(
        decoded.map((item) => Map<String, dynamic>.from(item as Map)),
      );
    } catch (e) {
      print('Error retrieving offline data: $e');
      return [];
    }
  }

  /// Check if offline data is still valid (not expired)
  bool isOfflineDataValid() {
    try {
      final lastSync = prefs.getInt(_lastSyncKey);
      if (lastSync == null) return false;

      final syncTime = DateTime.fromMillisecondsSinceEpoch(lastSync);
      final now = DateTime.now();
      final daysDifference = now.difference(syncTime).inDays;

      return daysDifference <= _maxOfflineDataRetentionDays;
    } catch (e) {
      return false;
    }
  }

  /// Get last sync time
  DateTime? getLastSyncTime() {
    try {
      final timestamp = prefs.getInt(_lastSyncKey);
      if (timestamp == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      return null;
    }
  }

  /// Get human-readable sync status
  String getSyncStatus() {
    final lastSync = getLastSyncTime();
    if (lastSync == null) {
      return 'Never synced';
    }

    final now = DateTime.now();
    final difference = now.difference(lastSync);

    if (difference.inSeconds < 60) {
      return 'Synced just now';
    } else if (difference.inMinutes < 60) {
      return 'Synced ${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return 'Synced ${difference.inHours} hours ago';
    } else {
      return 'Synced ${difference.inDays} days ago';
    }
  }

  /// Clear offline data
  Future<void> clearOfflineData() async {
    try {
      await prefs.remove(_offlineDataKey);
      await prefs.remove(_lastSyncKey);
    } catch (e) {
      print('Error clearing offline data: $e');
    }
  }

  /// Track pending changes for sync
  Future<void> addPendingChange(String towerId, Map<String, dynamic> change) async {
    try {
      final pendingChanges = getPendingChanges();
      pendingChanges[towerId] = change;
      await prefs.setString(_pendingChangesKey, jsonEncode(pendingChanges));
    } catch (e) {
      print('Error adding pending change: $e');
    }
  }

  /// Get pending changes
  Map<String, dynamic> getPendingChanges() {
    try {
      final jsonString = prefs.getString(_pendingChangesKey);
      if (jsonString == null) return {};
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    } catch (e) {
      return {};
    }
  }

  /// Clear pending changes after successful sync
  Future<void> clearPendingChanges() async {
    try {
      await prefs.remove(_pendingChangesKey);
    } catch (e) {
      print('Error clearing pending changes: $e');
    }
  }
}
