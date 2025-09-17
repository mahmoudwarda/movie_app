import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../core/bottoms/text_feild.dart';
import '../../core/colors_manger/colors.dart';
import '../../core/bottoms/buttons.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> updateProfile() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ You must login first")),
        );
        return;
      }

      final response = await http.put(
        Uri.parse("https://example.com/api/update-profile"), // عدل الرابط حسب API
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Profile updated successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ You must login first")),
        );
        return;
      }

      final response = await http.delete(
        Uri.parse("https://example.com/api/delete-account"), // عدل الرابط حسب API
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        // امسح التوكن بعد الحذف
        await prefs.remove("auth_token");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Account deleted successfully")),
        );

        // رجع المستخدم لشاشة تسجيل الدخول
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text(
          "Update Profile",
          style: TextStyle(
            color: AppColors.yellow,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
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
                  const SizedBox(height: 25),

                  // Name
                  CustomTextField(
                    controller: nameController,
                    hint: "Name",
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 15),

                  // Phone Number
                  CustomTextField(
                    controller: phoneController,
                    hint: "Phone Number",
                    prefixIcon: Icons.phone,
                  ),
                  const SizedBox(height: 15),

                  // Password
                  CustomTextField(
                    controller: passwordController,
                    hint: "Password",
                    obscureText: true,
                    prefixIcon: Icons.lock,
                  ),
                  const SizedBox(height: 15),

                  // Reset Password
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/reset-password");
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

            // Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 33),
              child: Column(
                children: [
                  CustomButton(
                    label: "Delete Account",
                    backgroundColor: AppColors.red,
                    textColor: Colors.white,
                    onPressed: deleteAccount,
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    label: isLoading ? "Updating..." : "Update Data",
                    onPressed: isLoading ? null : updateProfile,
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
