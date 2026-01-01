import 'package:equatable/equatable.dart';

abstract class TowerEvent extends Equatable {
  const TowerEvent();

  @override
  List<Object?> get props => [];
}

class LoadNearbyTowers extends TowerEvent {
  final double latitude;
  final double longitude;
  final double radiusKm;

  const LoadNearbyTowers({
    required this.latitude,
    required this.longitude,
    this.radiusKm = 10.0,
  });

  @override
  List<Object> get props => [latitude, longitude, radiusKm];
}

class PingTowerEvent extends TowerEvent {
  final String towerId;

  const PingTowerEvent(this.towerId);

  @override
  List<Object> get props => [towerId];
}

class RefreshTowers extends TowerEvent {
  final double latitude;
  final double longitude;

  const RefreshTowers({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];
}

class LoadCachedTowers extends TowerEvent {}
