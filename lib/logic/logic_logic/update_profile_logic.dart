import 'package:flutter/material.dart';
import 'package:movie/services/api_service.dart';


class UpdateProfileLogic {
  static Future<void> updateProfile(
      BuildContext context, String name, String phone, String password) async {
    String? message =
    await ApiService.updateProfile(name, phone, password);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? "Error")),
      );
    }
  }

  static Future<void> deleteAccount(BuildContext context) async {
    String? message = await ApiService.deleteAccount();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? "Error")),
      );
    }
  }

  static Future<void> resetPassword(
      BuildContext context, String oldPassword, String newPassword) async {
    String? message =
    await ApiService.resetPassword(oldPassword, newPassword);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? "Error")),
      );
    }
  }
}
