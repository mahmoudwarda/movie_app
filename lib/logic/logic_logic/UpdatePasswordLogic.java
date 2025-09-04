import 'package:flutter/material.dart';
import 'package:movie/services/api_service.dart';

class UpdatePasswordLogic {
  static Future<void> handleUpdatePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    try {
      final result = await ApiService.resetPassword(oldPassword, newPassword);
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
