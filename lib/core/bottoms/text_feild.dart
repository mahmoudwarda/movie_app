import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors_manger/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final IconData? prefixIcon;
  final TextEditingController controller; // عشان نمسك القيم

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: AppColors.white, fontSize: 16.sp),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: AppColors.white, fontSize: 16.sp),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.white, size: 24.sp)
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        filled: true,
        fillColor: AppColors.grey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
