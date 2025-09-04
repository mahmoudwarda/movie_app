import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie/core/routes_manegar/routes.dart';
import '../../core/models/onboarding/onboarding_model.dart';
import '../onboarding/onboarding_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishOnboarding() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    // Initializing ScreenUtil
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) {
        return Scaffold(
          body: PageView.builder(
            controller: _controller,
            itemCount: onboardingPages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                data: onboardingPages[index],
                isFirstPage: index == 0,
                isLastPage: index == onboardingPages.length - 1,
                onNext: _nextPage,
                onBack: _previousPage,
                onFinish: _finishOnboarding,
              );
            },
          ),
        );
      },
    );
  }
}
