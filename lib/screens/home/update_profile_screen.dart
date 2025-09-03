import 'package:flutter/material.dart';
import '../../core/bottoms/text_feild.dart';
import '../../core/colors_manger/colors.dart';
import '../../core/bottoms/buttons.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});

  final nameController = TextEditingController(text: "John Safwat");
  final phoneController = TextEditingController(text: "0120000000");
  final passwordController = TextEditingController();

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
                  // Avatar
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

                  // Phone Number
                  CustomTextField(hint: "Phone Number", controller: phoneController),
                  const SizedBox(height: 15),

                  // Reset Password (clickable text)
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Reset Password pressed")),
                      );
                    },
                    child: const Text(
                      "Reset Password",
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Buttons at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 33),
              child: Column(
                children: [
                  CustomButton(
                    label: "Delete Account",
                    backgroundColor: AppColors.red,
                    textColor: Colors.white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Delete pressed"), backgroundColor: AppColors.red),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    label: "Update Data",
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Update pressed"), backgroundColor: AppColors.yellow),
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
