import 'package:flutter/material.dart';
import 'package:movie/logic/logic_logic/update_profile_logic.dart';
import '../../core/bottoms/text_feild.dart';
import '../../core/colors_manger/colors.dart';
import '../../core/bottoms/buttons.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});

  final nameController = TextEditingController(text: "John Safwat");
  final phoneController = TextEditingController(text: "0120000000");
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text("Update Profile"),
        backgroundColor: AppColors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: const TextStyle(color: AppColors.white, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[900],
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/avatar.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name
                  CustomTextField(hint: "Name", controller: nameController),
                  const SizedBox(height: 15),

                  // Phone
                  CustomTextField(
                      hint: "Phone Number", controller: phoneController),
                  const SizedBox(height: 15),

                  // Old Password
                  CustomTextField(
                      hint: "Old Password", controller: oldPasswordController),
                  const SizedBox(height: 15),

                  // New Password
                  CustomTextField(
                      hint: "New Password", controller: newPasswordController),
                  const SizedBox(height: 20),

                  // Reset Password Button
                  CustomButton(
                    label: "Reset Password",
                    onPressed: () {
                      UpdateProfileLogic.resetPassword(
                        context,
                        oldPasswordController.text,
                        newPasswordController.text,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 33),
              child: Column(
                children: [
                  CustomButton(
                    label: "Delete Account",
                    backgroundColor: AppColors.red,
                    textColor: Colors.white,
                    onPressed: () {
                      UpdateProfileLogic.deleteAccount(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    label: "Update Data",
                    onPressed: () {
                      UpdateProfileLogic.updateProfile(
                        context,
                        nameController.text,
                        phoneController.text,
                        newPasswordController.text,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
