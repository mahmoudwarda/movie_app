import 'package:flutter/material.dart';
import 'package:movie/services/api_service.dart';


class ForgetPasswordLogic {
  static Future<void> sendResetLink(
      BuildContext context, String email) async {
    String? message = await ApiService.forgetPassword(email);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? "Error")),
      );
    }
  }
}
