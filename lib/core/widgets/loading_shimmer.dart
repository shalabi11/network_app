import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingShimmer({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}

class TowerListShimmer extends StatelessWidget {
  const TowerListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      padding: EdgeInsets.all(16.w),
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 16.h),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingShimmer(width: 150.w, height: 20.h),
                SizedBox(height: 12.h),
                LoadingShimmer(width: 100.w, height: 16.h),
                SizedBox(height: 8.h),
                LoadingShimmer(width: 120.w, height: 16.h),
                SizedBox(height: 8.h),
                LoadingShimmer(width: 80.w, height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
