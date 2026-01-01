import 'package:equatable/equatable.dart';
import '../../domain/entities/cellular_tower.dart';

abstract class TowerState extends Equatable {
  const TowerState();
  
  @override
  List<Object?> get props => [];
}

class TowerInitial extends TowerState {}

class TowerLoading extends TowerState {}

class TowerLoaded extends TowerState {
  final List<CellularTower> towers;
  final double? userLatitude;
  final double? userLongitude;
  
  const TowerLoaded({
    required this.towers,
    this.userLatitude,
    this.userLongitude,
  });
  
  @override
  List<Object?> get props => [towers, userLatitude, userLongitude];
}

class TowerError extends TowerState {
  final String message;
  
  const TowerError(this.message);
  
  @override
  List<Object> get props => [message];
}

class TowerPinging extends TowerState {
  final String towerId;
  
  const TowerPinging(this.towerId);
  
  @override
  List<Object> get props => [towerId];
}

class TowerPinged extends TowerState {
  final String towerId;
  final int latency;
  
  const TowerPinged({
    required this.towerId,
    required this.latency,
  });
  
  @override
  List<Object> get props => [towerId, latency];
}
