import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/colors_manger/colors.dart';
import '../core/models/onboarding/onboarding_model.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final bool isFirstPage;
  final bool isLastPage;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final VoidCallback? onFinish;

  const OnboardingPage({
    super.key,
    required this.data,
    this.isFirstPage = false,
    this.isLastPage = false,
    this.onNext,
    this.onBack,
    this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            data.image,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.8), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isFirstPage) ...[
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.title,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      if (data.subtitle != null)
                        Text(
                          data.subtitle!,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(height: 32.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: onNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                            ),
                            child: Text(
                              "Explore",
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r),
                    ),
                  ),
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.title,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      if (data.subtitle != null)
                        Text(
                          data.subtitle!,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(height: 24.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: SizedBox(
                              height: 50.h,
                              child: ElevatedButton(
                                onPressed: isLastPage ? onFinish : onNext,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.yellow,
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ),
                                child: Text(
                                  isLastPage ? "Finish" : "Next",
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ),
                            ),
                          ),
                          if (!isFirstPage) ...[
                            SizedBox(height: 12.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: SizedBox(
                                height: 50.h,
                                child: OutlinedButton(
                                  onPressed: onBack,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.yellow,
                                    side: BorderSide(
                                      color: AppColors.yellow,
                                      width: 2.w,
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 14.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                  ),
                                  child: Text(
                                    "Back",
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
