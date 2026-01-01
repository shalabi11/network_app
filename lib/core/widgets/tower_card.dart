import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/towers/domain/entities/cellular_tower.dart';
import '../utils/extensions.dart';

class TowerCard extends StatelessWidget {
  final CellularTower tower;
  final VoidCallback? onTap;
  final VoidCallback? onPing;
  final bool showDetails;
  final double? userLatitude;
  final double? userLongitude;

  const TowerCard({
    Key? key,
    required this.tower,
    this.onTap,
    this.onPing,
    this.showDetails = false,
    this.userLatitude,
    this.userLongitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final distance = (userLatitude != null && userLongitude != null)
        ? tower.distanceFrom(userLatitude!, userLongitude!)
        : null;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tower.isAccessible ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      tower.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (tower.status == 'online')
                    Icon(
                      Icons.signal_cellular_alt,
                      color: Colors.green,
                      size: 24.sp,
                    )
                  else
                    Icon(
                      Icons.signal_cellular_off,
                      color: Colors.red,
                      size: 24.sp,
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.signal_cellular_4_bar,
                    size: 16.sp,
                    color: tower.signalStrength.signalStrengthColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '${tower.signalStrength} dBm',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: tower.signalStrength.signalStrengthColor
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      tower.signalStrength.signalStrengthLabel,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: tower.signalStrength.signalStrengthColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (showDetails) ...[
                SizedBox(height: 12.h),
                if (distance != null)
                  _buildDetailRow(
                    Icons.location_on,
                    'Distance',
                    '${distance.toStringAsFixed(2)} km',
                    context,
                  ),
                if (tower.networkType != null)
                  _buildDetailRow(
                    Icons.network_cell,
                    'Network Type',
                    tower.networkType!,
                    context,
                  ),
                if (tower.pingLatency != null)
                  _buildDetailRow(
                    Icons.speed,
                    'Ping',
                    '${tower.pingLatency} ms',
                    context,
                  ),
                if (tower.downloadSpeed != null)
                  _buildDetailRow(
                    Icons.download,
                    'Download',
                    '${tower.downloadSpeed!.toStringAsFixed(1)} Mbps',
                    context,
                  ),
                if (tower.uploadSpeed != null)
                  _buildDetailRow(
                    Icons.upload,
                    'Upload',
                    '${tower.uploadSpeed!.toStringAsFixed(1)} Mbps',
                    context,
                  ),
              ],
              if (onPing != null) ...[
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onPing,
                    icon: const Icon(Icons.network_ping),
                    label: const Text('Ping Tower'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: Colors.grey[600]),
          SizedBox(width: 8.w),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
