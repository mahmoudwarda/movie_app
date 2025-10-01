import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie/core/colors_manger/colors.dart';
import 'package:movie/screens/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 4),

            Image.asset(
              "assets/images/logo.png",
              height: 150.h,
              width: 150.w,
              fit: BoxFit.contain,
            ),

            const Spacer(flex: 3),

            Image.asset(
              "assets/images/route.png",
              height: 50.h,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 10.h),

            Text(
              "Supervised by Mohamed Nabil",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
