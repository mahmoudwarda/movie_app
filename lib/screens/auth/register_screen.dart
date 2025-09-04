import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/bottoms/text_feild.dart';
import '../../core/colors_manger/colors.dart';
import '../../core/bottoms/buttons.dart';
import 'login_screen.dart';

class SvgFlag extends StatelessWidget {
  final String assetPath;
  final double radius;

  const SvgFlag({
    super.key,
    required this.assetPath,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius.w,
      backgroundColor: Colors.transparent,
      child: SvgPicture.asset(
        assetPath,
        width: radius.w * 2,
        height: radius.h * 2,
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.yellow, size: 24.sp),
        ),
        title: Text(
          "Register",
          style: TextStyle(color: AppColors.yellow, fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Avatars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundImage: const AssetImage("assets/images/av_1.png"),
                ),
                SizedBox(width: 16.w),
                CircleAvatar(
                  radius: 40.r,
                  backgroundImage: const AssetImage("assets/images/av_2.png"),
                ),
                SizedBox(width: 16.w),
                CircleAvatar(
                  radius: 30.r,
                  backgroundImage: const AssetImage("assets/images/av_3.png"),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              "Avatar",
              style: TextStyle(color: AppColors.white, fontSize: 16.sp),
            ),
            SizedBox(height: 20.h),

            CustomTextField(
              hint: "Name",
              controller: nameController,
              prefixIcon: Icons.person,
            ),
            SizedBox(height: 12.h),
            CustomTextField(
              hint: "Email",
              controller: emailController,
              prefixIcon: Icons.email_outlined,
            ),
            SizedBox(height: 12.h),
            CustomTextField(
              hint: "Password",
              controller: passwordController,
              obscureText: true,
              prefixIcon: Icons.lock_outline,
            ),
            SizedBox(height: 12.h),
            CustomTextField(
              hint: "Confirm Password",
              controller: confirmPasswordController,
              obscureText: true,
              prefixIcon: Icons.lock_outline,
            ),
            SizedBox(height: 12.h),
            CustomTextField(
              hint: "Phone Number",
              controller: phoneController,
              prefixIcon: Icons.phone,
            ),
            SizedBox(height: 20.h),

            CustomButton(
              label: "Create Account",
              onPressed: () {},
            ),
            SizedBox(height: 10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already Have Account? ",
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: AppColors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

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
