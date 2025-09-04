import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie/logic/logic_logic/forget_password.dart';
import '../../core/bottoms/text_feild.dart';
import '../../core/colors_manger/colors.dart';
import '../../core/bottoms/buttons.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(
          "Forget Password",
          style: TextStyle(fontSize: 20.sp),
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
              // صورة فوق
              Image.asset(
                "assets/images/forgot_password.png",
                height: 200.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 30.h),

              // حقل إدخال الإيميل
              CustomTextField(
                hint: "Email",
                controller: emailController,
                prefixIcon: Icons.email_outlined,
              ),
              SizedBox(height: 30.h),

              // زرار Verify
              CustomButton(
                label: "Verify Email",
                onPressed: () {
                  if (emailController.text.isNotEmpty) {
                    ForgetPasswordLogic.handleForgetPassword(
                      context,
                      emailController.text,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter your email"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
