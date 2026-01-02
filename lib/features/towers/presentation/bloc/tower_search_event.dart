import 'package:equatable/equatable.dart';
import '../../domain/entities/cellular_tower.dart';

abstract class TowerSearchEvent extends Equatable {
  const TowerSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchTowersEvent extends TowerSearchEvent {
  final String query;
  final List<CellularTower> allTowers;

  const SearchTowersEvent({
    required this.query,
    required this.allTowers,
  });

  @override
  List<Object?> get props => [query, allTowers];
}

class ClearSearchEvent extends TowerSearchEvent {
  const ClearSearchEvent();
}
