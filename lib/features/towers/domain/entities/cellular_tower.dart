import 'dart:math';
import 'package:equatable/equatable.dart';

class CellularTower extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final bool isAccessible;
  final int signalStrength; // in dBm
  final String status; // online, offline, unknown
  final String? networkType; // 4G, 5G, etc.
  final int? pingLatency; // in ms
  final double? uploadSpeed; // in Mbps
  final double? downloadSpeed; // in Mbps
  final DateTime? lastUpdated;

  const CellularTower({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.isAccessible,
    required this.signalStrength,
    required this.status,
    this.networkType,
    this.pingLatency,
    this.uploadSpeed,
    this.downloadSpeed,
    this.lastUpdated,
  });

  double distanceFrom(double latitude, double longitude) {
    // Haversine formula to calculate distance
    const double earthRadius = 6371; // km

    final double dLat = _toRadians(this.latitude - latitude);
    final double dLon = _toRadians(this.longitude - longitude);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(latitude)) *
            cos(_toRadians(this.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * 3.14159265359 / 180;
  }

  CellularTower copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    bool? isAccessible,
    int? signalStrength,
    String? status,
    String? networkType,
    int? pingLatency,
    double? uploadSpeed,
    double? downloadSpeed,
    DateTime? lastUpdated,
  }) {
    return CellularTower(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isAccessible: isAccessible ?? this.isAccessible,
      signalStrength: signalStrength ?? this.signalStrength,
      status: status ?? this.status,
      networkType: networkType ?? this.networkType,
      pingLatency: pingLatency ?? this.pingLatency,
      uploadSpeed: uploadSpeed ?? this.uploadSpeed,
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    latitude,
    longitude,
    isAccessible,
    signalStrength,
    status,
    networkType,
    pingLatency,
    uploadSpeed,
    downloadSpeed,
    lastUpdated,
  ];
}
