import 'package:flutter/material.dart';
import 'package:movie/services/api_service.dart';

class ForgetPasswordLogic {
  static Future<void> handleForgetPassword(
      BuildContext context, String email) async {
    try {
      final result = await ApiService.forgetPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? "Unexpected error")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
