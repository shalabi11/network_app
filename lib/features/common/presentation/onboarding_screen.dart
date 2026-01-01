import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../injection_container.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Welcome to Network App',
          body: 'Monitor cellular towers and network performance in real-time',
          image: Center(
            child: Icon(
              Icons.cell_tower,
              size: 150.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(fontSize: 16.sp),
          ),
        ),
        PageViewModel(
          title: 'View Towers on Map',
          body: 'See nearby cellular towers with accessibility status',
          image: Center(
            child: Icon(
              Icons.map,
              size: 150.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(fontSize: 16.sp),
          ),
        ),
        PageViewModel(
          title: 'Track Network Stats',
          body: 'Monitor signal strength, ping, and connection quality',
          image: Center(
            child: Icon(
              Icons.analytics,
              size: 150.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
            bodyTextStyle: TextStyle(fontSize: 16.sp),
          ),
        ),
      ],
      onDone: () => _onDone(context),
      onSkip: () => _onDone(context),
      showSkipButton: true,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: Size.square(10.sp),
        activeSize: Size(20.sp, 10.sp),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
      ),
    );
  }
  
  Future<void> _onDone(BuildContext context) async {
    final prefs = sl<SharedPreferences>();
    await prefs.setBool(AppConstants.keyFirstLaunch, false);
    
    if (!context.mounted) return;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}
