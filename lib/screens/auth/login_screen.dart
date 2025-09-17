  import 'package:flutter/material.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import '../../core/colors_manger/colors.dart';
  import '../../core/utils/api_service.dart';
  import 'forget_password_screen.dart';
  import 'register_screen.dart';

  class LoginScreen extends StatefulWidget {
    const LoginScreen({super.key});

    @override
    State<LoginScreen> createState() => _LoginScreenState();
  }

  class _LoginScreenState extends State<LoginScreen> {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool isLoading = false;

    Future<void> _login() async {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter email and password")),
        );
        return;
      }

      setState(() => isLoading = true);

      try {
        final response = await ApiService.login(email: email, password: password);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", response.token ?? "");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Login Successful")),
        );


      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Failed: $e")),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }

    @override
    Widget build(BuildContext context) {
      ScreenUtil.init(context, designSize: const Size(360, 690));

      return Scaffold(
        backgroundColor: AppColors.black,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60.h),
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 160.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 18.h),

              // Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: AppColors.white),
                  hintText: "Email",
                  hintStyle: const TextStyle(color: AppColors.white),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: AppColors.white),
              ),
              SizedBox(height: 20.h),

              // Password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: AppColors.white),
                  suffixIcon: const Icon(Icons.visibility_off, color: AppColors.white),
                  hintText: "Password",
                  hintStyle: const TextStyle(color: AppColors.white),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: AppColors.white),
              ),
              SizedBox(height: 10.h),

              // Forget password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
                    );
                  },
                  child: const Text(
                    "Forget Password?",
                    style: TextStyle(color: AppColors.yellow),
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.black,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  onPressed: isLoading ? null : _login,
                  child: isLoading
                      ? const CircularProgressIndicator(color: AppColors.black)
                      : Text("Login", style: TextStyle(fontSize: 18.sp)),
                ),
              ),
              SizedBox(height: 20.h),

              // Create account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t Have Account? ", style: TextStyle(color: AppColors.grey)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Create One",
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Divider OR
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[600], thickness: 1.h)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: const Text("OR", style: TextStyle(color: AppColors.yellow)),
                  ),
                  Expanded(child: Divider(color: Colors.grey[600], thickness: 1.h)),
                ],
              ),
              SizedBox(height: 20.h),

              // Google button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.black,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/images/google.svg',
                    height: 24.h,
                    width: 24.w,
                  ),
                  label: Text("Login With Google", style: TextStyle(fontSize: 16.sp)),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
