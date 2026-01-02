import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:network_app/features/speed_test/presentation/bloc/speed_test_bloc.dart';
import 'package:network_app/features/speed_test/presentation/bloc/speed_test_event.dart';
import 'package:network_app/features/speed_test/presentation/bloc/speed_test_state.dart';
import 'package:network_app/injection_container.dart';

class SpeedTestScreen extends StatelessWidget {
  const SpeedTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SpeedTestBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Internet Speed Test')),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: BlocBuilder<SpeedTestBloc, SpeedTestState>(
            builder: (context, state) {
              double downloadSpeed = 0;
              double uploadSpeed = 0;
              bool isDownloading = false;
              bool isUploading = false;
              bool isDone = false;
              String? error;

              if (state is SpeedTestRunInProgress) {
                downloadSpeed = state.result.downloadSpeed;
                uploadSpeed = state.result.uploadSpeed;
                isDownloading = state.result.isDownloading;
                isUploading = state.result.isUploading;
              } else if (state is SpeedTestRunComplete) {
                downloadSpeed = state.result.downloadSpeed;
                uploadSpeed = state.result.uploadSpeed;
                isDone = true;
              } else if (state is SpeedTestRunFailure) {
                error = state.message;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (error != null)
                    Text(
                      'Error: $error',
                      style: TextStyle(color: Colors.red, fontSize: 16.sp),
                    ),
                  _buildSpeedCard(
                    title: 'Download',
                    speed: downloadSpeed,
                    isActive: isDownloading,
                    icon: Icons.download,
                    color: Colors.green,
                  ),
                  SizedBox(height: 20.h),
                  _buildSpeedCard(
                    title: 'Upload',
                    speed: uploadSpeed,
                    isActive: isUploading,
                    icon: Icons.upload,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 40.h),
                  if (!isDownloading && !isUploading)
                    ElevatedButton(
                      onPressed: () {
                        context.read<SpeedTestBloc>().add(SpeedTestStarted());
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 15.h,
                        ),
                      ),
                      child: Text(
                        isDone ? 'Restart Test' : 'Start Test',
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                  if (isDownloading || isUploading)
                    const CircularProgressIndicator(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedCard({
    required String title,
    required double speed,
    required bool isActive,
    required IconData icon,
    required Color color,
  }) {
    final speedMB = speed / 8; // Convert Mbps to MB/s
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Icon(icon, size: 40.sp, color: isActive ? color : Colors.grey),
            SizedBox(width: 20.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  '${speed.toStringAsFixed(2)} Mbps',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isActive ? color : Colors.black,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '${speedMB.toStringAsFixed(2)} MB/s',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
