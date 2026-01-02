import 'package:flutter_bloc/flutter_bloc.dart';
import 'tower_search_event.dart';
import 'tower_search_state.dart';

class TowerSearchBloc extends Bloc<TowerSearchEvent, TowerSearchState> {
  TowerSearchBloc() : super(const SearchInitial()) {
    on<SearchTowersEvent>(_onSearchTowers);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchTowers(
    SearchTowersEvent event,
    Emitter<TowerSearchState> emit,
  ) async {
    emit(const SearchLoading());

    // Simulate small delay for better UX
    await Future.delayed(const Duration(milliseconds: 300));

    final query = event.query.toLowerCase().trim();

    if (query.isEmpty) {
      emit(SearchResults(
        towers: event.allTowers,
        query: query,
        totalResults: event.allTowers.length,
      ));
      return;
    }

    // Search by multiple criteria
    final results = event.allTowers.where((tower) {
      return tower.id.toLowerCase().contains(query) ||
          tower.name.toLowerCase().contains(query) ||
          (tower.operatorName?.toLowerCase().contains(query) ?? false) ||
          (tower.networkType?.toLowerCase().contains(query) ?? false);
    }).toList();

    if (results.isEmpty) {
      emit(SearchEmpty(query));
    } else {
      emit(SearchResults(
        towers: results,
        query: query,
        totalResults: results.length,
      ));
    }
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<TowerSearchState> emit,
  ) async {
    emit(const SearchInitial());
  }
}
