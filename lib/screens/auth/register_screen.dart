import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/bottoms/text_feild.dart';
import '../../core/bottoms/buttons.dart';
import '../../core/colors_manger/colors.dart';
import '../../core/routes_manegar/routes.dart';
import '../../core/utils/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  int selectedAvatar = 1;
  bool isLoading = false;

  // Validate Email
  bool _isValidEmail(String email) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  // Parse message from server
  String _parseMessage(dynamic message) {
    if (message is String) return message;
    if (message is List) return message.join(", ");
    return "Unknown response from server";
  }

  Future<void> _register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final AuthResponse response = await ApiService.register(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phone: phone,
        avatarId: selectedAvatar,
      );

      final message = _parseMessage(response.message);

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Register Successful: $message")),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed: $message")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Register Failed: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildTextField(
      TextEditingController controller, String hint, IconData icon,
      {bool obscure = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: CustomTextField(
        controller: controller,
        hint: hint,
        prefixIcon: icon,
        obscureText: obscure,
      ),
    );
  }

  Widget buildAvatar(int id) {
    return GestureDetector(
      onTap: () => setState(() => selectedAvatar = id),
      child: CircleAvatar(
        radius: selectedAvatar == id ? 40.r : 30.r,
        backgroundImage: AssetImage("assets/images/av_$id.png"),
        backgroundColor:
        selectedAvatar == id ? AppColors.yellow : Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
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
                  children: List.generate(
                    3,
                        (index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: buildAvatar(index + 1),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text("Choose Avatar",
                    style: TextStyle(color: AppColors.white, fontSize: 16.sp)),
                SizedBox(height: 20.h),

                // TextFields
                buildTextField(nameController, "Name", Icons.person),
                buildTextField(emailController, "Email", Icons.email_outlined),
                buildTextField(passwordController, "Password", Icons.lock_outline,
                    obscure: true),
                buildTextField(confirmPasswordController, "Confirm Password",
                    Icons.lock_outline,
                    obscure: true),
                buildTextField(phoneController, "Phone Number", Icons.phone),
                SizedBox(height: 20.h),

                // Register Button
                CustomButton(
                  onPressed: isLoading ? null : _register,
                  label: isLoading ? "Loading..." : "Create Account",
                ),
                SizedBox(height: 10.h),

                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already Have Account? ",
                        style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, AppRoutes.login),
                      child: Text("Login",
                          style: TextStyle(
                              color: AppColors.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
