import 'package:equatable/equatable.dart';

class NetworkStats extends Equatable {
  final int signalStrength; // in dBm
  final int pingLatency; // in ms
  final double uploadSpeed; // in Mbps
  final double downloadSpeed; // in Mbps
  final String connectionQuality; // excellent, good, fair, weak
  final String networkType; // 4G, 5G, etc.
  final DateTime timestamp;

  const NetworkStats({
    required this.signalStrength,
    required this.pingLatency,
    required this.uploadSpeed,
    required this.downloadSpeed,
    required this.connectionQuality,
    required this.networkType,
    required this.timestamp,
  });

  @override
  List<Object> get props => [
    signalStrength,
    pingLatency,
    uploadSpeed,
    downloadSpeed,
    connectionQuality,
    networkType,
    timestamp,
  ];
}
