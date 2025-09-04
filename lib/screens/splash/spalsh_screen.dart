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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
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
            Image.asset(
              "assets/images/logo.png",
              height: 150.h,
              width: 150.w,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 50),
            Image.asset(
              "assets/images/route.png",
              height: 80.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 12.h),
            Text(
              "Supervised by Mohamed Nabil",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
