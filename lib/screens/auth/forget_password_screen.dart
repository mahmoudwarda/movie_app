import 'package:flutter/material.dart';
import 'package:movie/logic/logic_logic/forget_password.dart';
import '../../core/colors_manger/colors.dart';
import '../../core/bottoms/text_feild.dart';
import '../../core/bottoms/buttons.dart';


class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text("Forget Password"),
        backgroundColor: AppColors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: const TextStyle(color: AppColors.white, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              hint: "Enter your email",
              controller: emailController,
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Send Reset Link",
              onPressed: () {
                ForgetPasswordLogic.sendResetLink(
                  context,
                  emailController.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
