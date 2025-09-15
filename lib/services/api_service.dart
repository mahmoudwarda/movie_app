import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String userBaseUrl = 'https://yourapi.com';
  static const String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...";

  /// ✅ Update Profile
  static Future<String?> updateProfile(
      String name, String phone, String password) async {
    final url = Uri.parse('$userBaseUrl/user/update');
    final response = await http.put(
      url,
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
      final data = jsonDecode(response.body);
      return data['message'];
    } else {
      return "Failed: ${response.body}";
    }
  }

  /// ✅ Delete Account
  static Future<String?> deleteAccount() async {
    final url = Uri.parse('$userBaseUrl/user/delete');
    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return "Account deleted successfully";
    } else {
      return "Failed: ${response.body}";
    }
  }

  /// ✅ Reset Password
  static Future<String?> resetPassword(
      String oldPassword, String newPassword) async {
    final url = Uri.parse('$userBaseUrl/auth/reset-password');
    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['message'];
    } else {
      return "Failed: ${response.body}";
    }
  }

  /// ✅ Forget Password (send email link)
  static Future<String?> forgetPassword(String email) async {
    final url = Uri.parse("$userBaseUrl/user/forgot-password");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["message"] ?? "Password reset link sent successfully";
      } else {
        return "Failed: ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
