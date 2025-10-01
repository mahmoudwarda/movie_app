import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../colors_manger/colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(Icons.movie, size: 40.sp, color: AppColors.white),
          ),
          SizedBox(height: 24.h),
          Text(
            'Welcome Back!',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            'Sign in to your account',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: AppColors.white, fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: 'Enter your $label',
        prefixIcon: Icon(isPassword ? Icons.lock_outline : Icons.email_outlined, color: AppColors.grey, size: 24.sp),
        filled: true,
        fillColor: AppColors.grey.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
      ),
    );
  }
}
