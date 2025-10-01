import 'package:flutter/material.dart';

import '../../screens/auth/forget_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/update_profile_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/splash/spalsh_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forget_password';

  // Home
  static const String home = '/home';
  static const String updateProfile = '/update_profile';
  static const String homeScreen = '/home_Screen';


  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    onboarding: (context) => OnboardingScreen(),
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    forgetPassword: (context) => ForgetPasswordScreen(),
    updateProfile: (context) => UpdateProfileScreen(),
    homeScreen: (context) => HomeScreenTab(),

  };
}