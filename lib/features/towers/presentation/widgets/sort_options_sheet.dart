import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/services/tower_sort_service.dart';

class SortOptionsBottomSheet extends StatelessWidget {
  final SortOption currentSortOption;
  final Function(SortOption) onSortSelected;

  const SortOptionsBottomSheet({
    super.key,
    required this.currentSortOption,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sort By',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16.h),
          _buildSortOption(
            context,
            'Name (A-Z)',
            SortOption.name,
          ),
          _buildSortOption(
            context,
            'Distance (Nearest)',
            SortOption.distance,
          ),
          _buildSortOption(
            context,
            'Signal Strength (Strongest)',
            SortOption.signal,
          ),
          _buildSortOption(
            context,
            'Newest',
            SortOption.newest,
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String label,
    SortOption option,
  ) {
    return ListTile(
      leading: Radio<SortOption>(
        value: option,
        groupValue: currentSortOption,
        onChanged: (value) {
          if (value != null) {
            onSortSelected(value);
            Navigator.pop(context);
          }
        },
      ),
      title: Text(label),
      onTap: () {
        onSortSelected(option);
        Navigator.pop(context);
      },
    );
  }
}
