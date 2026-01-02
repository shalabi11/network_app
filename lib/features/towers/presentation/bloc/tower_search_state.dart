import 'package:equatable/equatable.dart';
import '../../domain/entities/cellular_tower.dart';

abstract class TowerSearchState extends Equatable {
  const TowerSearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends TowerSearchState {
  const SearchInitial();
}

class SearchLoading extends TowerSearchState {
  const SearchLoading();
}

class SearchResults extends TowerSearchState {
  final List<CellularTower> towers;
  final String query;
  final int totalResults;

  const SearchResults({
    required this.towers,
    required this.query,
    required this.totalResults,
  });

  @override
  List<Object?> get props => [towers, query, totalResults];
}

class SearchEmpty extends TowerSearchState {
  final String query;

  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}
