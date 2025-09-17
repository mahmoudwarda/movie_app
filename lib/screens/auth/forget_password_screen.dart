import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/colors_manger/colors.dart';
import '../../core/bottoms/buttons.dart';
import '../../core/bottoms/text_feild.dart';
import '../../core/utils/api_service.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> _resetPassword() async {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both old and new password")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final message = await ApiService.resetPassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.yellow,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/forgot_password.png",
                height: 200.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                hint: "Old Password",
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                controller: oldPasswordController,
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                hint: "New Password",
                obscureText: true,
                prefixIcon: Icons.lock_reset,
                controller: newPasswordController,
              ),
              SizedBox(height: 30.h),
              CustomButton(
                label: isLoading ? "Loading..." : "Reset Password",
                onPressed: isLoading ? () {} : _resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
