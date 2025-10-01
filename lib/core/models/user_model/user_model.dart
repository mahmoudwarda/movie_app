import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String _profileKey = "local_user_profile";

class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int avaterId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avaterId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avaterId: json['avaterId'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avaterId': avaterId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }


  static Future<ProfileModel?> getLocalProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? profileString = prefs.getString(_profileKey);
      if (profileString != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(profileString);
        return ProfileModel.fromJson(jsonMap);
      }
    } catch (e) {
      print("Error loading local profile: $e");
    }
    return null;
  }

  static Future<void> saveLocalProfile(ProfileModel profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String profileString = jsonEncode(profile.toJson());
      await prefs.setString(_profileKey, profileString);
      print("Profile saved .");
    } catch (e) {
      print("Error saving local profile: $e");
    }
  }

  static Future<void> clearLocalProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
      print(" profile cleared.");
    } catch (e) {
      print("Error clearing local profile: $e");
    }
  }
}
