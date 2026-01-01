import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? animationAsset;
  final VoidCallback? onRetry;
  final String? retryText;
  
  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.animationAsset,
    this.onRetry,
    this.retryText,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (animationAsset != null)
              Lottie.asset(
                animationAsset!,
                width: 200.w,
                height: 200.h,
                fit: BoxFit.contain,
              )
            else
              Icon(
                Icons.inbox_outlined,
                size: 100.sp,
                color: Colors.grey,
              ),
            SizedBox(height: 24.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(retryText ?? 'Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
