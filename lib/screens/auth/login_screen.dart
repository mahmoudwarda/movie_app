import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/colors_manger/colors.dart';
import '../../core/widgets/svg/svg_flags.dart' hide SvgFlag;
import 'forget_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 60.h),
            Center(
              child: Image.asset(
                "assets/images/logo.png",
                height: 160.h,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 18.h),

            // Email
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: AppColors.white),
                hintText: "Email",
                hintStyle: const TextStyle(color: AppColors.white),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: AppColors.white),
            ),
            SizedBox(height: 20.h),

            // Password
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock, color: AppColors.white),
                suffixIcon: const Icon(Icons.visibility_off, color: AppColors.white),
                hintText: "Password",
                hintStyle: const TextStyle(color: AppColors.white),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: AppColors.white),
            ),
            SizedBox(height: 10.h),

            // Forget password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgetPasswordScreen()),
                  );
                },
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(color: AppColors.yellow),
                ),
              ),
            ),
            SizedBox(height: 10.h),

            // Login button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: AppColors.black,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 18.sp),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Create account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don’t Have Account? ",
                  style: TextStyle(color: AppColors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    "Create One",
                    style: TextStyle(
                      color: AppColors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Divider OR
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[600], thickness: 1.h)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: const Text("OR", style: TextStyle(color: AppColors.yellow)),
                ),
                Expanded(child: Divider(color: Colors.grey[600], thickness: 1.h)),
              ],
            ),
            SizedBox(height: 20.h),

            // Google button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: AppColors.black,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/images/google.svg',
                  height: 24.h,
                  width: 24.w,
                ),
                label: Text(
                  "Login With Google",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
            SizedBox(height: 30.h),

            // Flags
            Center(
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  border: Border.all(color: AppColors.yellow, width: 2.w),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SvgFlag(assetPath: "assets/images/english.svg", radius: 20),
                    SizedBox(width: 8),
                    SvgFlag(assetPath: "assets/images/eg.svg", radius: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
