import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tower_search_bloc.dart';
import '../bloc/tower_search_event.dart';
import '../bloc/tower_state.dart' as tower_state;

class TowerSearchBar extends StatefulWidget {
  final tower_state.TowerState currentTowerState;

  const TowerSearchBar({
    super.key,
    required this.currentTowerState,
  });

  @override
  State<TowerSearchBar> createState() => _TowerSearchBarState();
}

class _TowerSearchBarState extends State<TowerSearchBar> {
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (widget.currentTowerState is tower_state.TowerLoaded) {
      final towers = (widget.currentTowerState as tower_state.TowerLoaded).towers;
      context.read<TowerSearchBloc>().add(
        SearchTowersEvent(query: query, allTowers: towers),
      );
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _isSearching = false);
    context.read<TowerSearchBloc>().add(const ClearSearchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isSearching ? 100.h : 60.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _performSearch,
            onTap: () => setState(() => _isSearching = true),
            decoration: InputDecoration(
              hintText: 'Search towers (ID, MCC, MNC, LAC, CID)...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearSearch,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
