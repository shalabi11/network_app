import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/services/statistics_service.dart';

class StatisticsBottomSheet extends StatelessWidget {
  final TowerStatistics statistics;

  const StatisticsBottomSheet({
    super.key,
    required this.statistics,
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
            'Tower Statistics',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16.h),
          _buildStatCard(context, 'Total Towers', '${statistics.totalTowers}'),
          _buildStatCard(context, 'Avg Signal', '${statistics.averageSignal.toStringAsFixed(1)} dBm'),
          _buildStatCard(context, 'Strongest', '${statistics.strongestSignal} dBm'),
          _buildStatCard(context, 'Weakest', '${statistics.weakestSignal} dBm'),
          SizedBox(height: 16.h),
          Text(
            'Distance Statistics',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          _buildStatCard(context, 'Avg Distance', '${statistics.averageDistance.toStringAsFixed(1)} km'),
          _buildStatCard(context, 'Nearest', '${statistics.nearestDistance} km'),
          _buildStatCard(context, 'Farthest', '${statistics.farthestDistance} km'),
          SizedBox(height: 16.h),
          if (statistics.towersPerType.isNotEmpty)
            _buildNetworkTypes(context, statistics.towersPerType),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkTypes(BuildContext context, Map<String, int> types) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Towers by Type',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 8.h),
        ...types.entries.map((entry) => _buildStatCard(context, entry.key, '${entry.value}')),
      ],
    );
  }
}
