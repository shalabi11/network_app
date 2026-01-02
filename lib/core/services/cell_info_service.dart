import 'package:flutter/services.dart';
import '../utils/logger.dart';

/// Service to get currently connected cell tower information
class CellInfoService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.network_app/cell_info',
  );

  /// Get information about the currently connected cell tower
  /// Returns null if unable to get cell info or permission denied
  static Future<ConnectedCellInfo?> getConnectedCell() async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeMethod(
        'getConnectedCell',
      );

      if (result == null || result.isEmpty) {
        AppLogger.debug('No connected cell info available');
        return null;
      }

      final mcc = result['mcc'] as int?;
      final mnc = result['mnc'] as int?;
      final lac = result['lac'] as int?;
      final cellId = result['cellId'] as int?;

      if (mcc == null || mnc == null || lac == null || cellId == null) {
        AppLogger.debug('Incomplete cell info data');
        return null;
      }

      AppLogger.info(
        'Connected to cell: MCC=$mcc, MNC=$mnc, LAC=$lac, CellID=$cellId',
      );

      return ConnectedCellInfo(
        mcc: mcc,
        mnc: mnc,
        lac: lac,
        cellId: cellId,
        networkType: result['networkType'] as String?,
        signalStrength: result['signalStrength'] as int?,
      );
    } on PlatformException catch (e) {
      AppLogger.error('Platform error getting cell info: ${e.message}', e);
      return null;
    } catch (e) {
      AppLogger.error('Error getting connected cell info', e);
      return null;
    }
  }

  /// Generate tower ID in the same format as OpenCelliD API
  static String generateTowerId({
    required int mcc,
    required int mnc,
    required int lac,
    required int cellId,
  }) {
    return '$mcc-$mnc-$lac-$cellId';
  }
}

/// Information about the currently connected cell tower
class ConnectedCellInfo {
  final int mcc; // Mobile Country Code
  final int mnc; // Mobile Network Code
  final int lac; // Location Area Code (or TAC for LTE)
  final int cellId; // Cell ID
  final String? networkType; // GSM, LTE, WCDMA, NR
  final int? signalStrength; // Signal strength in dBm

  const ConnectedCellInfo({
    required this.mcc,
    required this.mnc,
    required this.lac,
    required this.cellId,
    this.networkType,
    this.signalStrength,
  });

  /// Get tower ID in OpenCelliD format
  String get towerId => CellInfoService.generateTowerId(
    mcc: mcc,
    mnc: mnc,
    lac: lac,
    cellId: cellId,
  );

  @override
  String toString() {
    return 'ConnectedCellInfo(mcc: $mcc, mnc: $mnc, lac: $lac, cellId: $cellId, type: $networkType)';
  }
}
