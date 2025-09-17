import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie_model/movie_model.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => "ApiException: $message";
}

class LocalStorage {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final String? token;

  AuthResponse({required this.success, required this.message, this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
    );
  }
}

class ApiService {
  static const String moviesBaseUrl = 'https://yts.mx/api/v2';
  static const String authBaseUrl = 'https://route-movie-apis.vercel.app';

  static dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw ApiException(data['message'] ?? 'Something went wrong');
    }
  }

  // --- Auth methods ---
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$authBaseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    final data = _handleResponse(response);
    final auth = AuthResponse.fromJson(data);

    if (auth.success && auth.token != null) {
      await LocalStorage.saveToken(auth.token!);
    }

    return auth;
  }

  static Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required int avatarId,
  }) async {
    final url = Uri.parse('$authBaseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "phone": phone,
        "avatarId": avatarId,
      }),
    );
    final data = _handleResponse(response);
    return AuthResponse.fromJson(data);
  }

  static Future<String> resetPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final token = await LocalStorage.getToken();
    if (token == null) throw ApiException("User not logged in");

    final url = Uri.parse('$authBaseUrl/auth/reset-password');
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

    final data = _handleResponse(response);
    return data['message'] ?? "Password reset successful";
  }

  static Future<String> updateProfile({
    String? email,
    String? name,
    String? phone,
    int? avatarId,
  }) async {
    final token = await LocalStorage.getToken();
    if (token == null) throw ApiException("User not logged in");

    final url = Uri.parse('$authBaseUrl/profile');
    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        if (email != null) "email": email,
        if (name != null) "name": name,
        if (phone != null) "phone": phone,
        if (avatarId != null) "avatarId": avatarId,
      }),
    );

    final data = _handleResponse(response);
    return data['message'] ?? "Profile updated successfully";
  }

  // --- Movies API ---
  static Future<List<MovieModel>> getMovies({int page = 1}) async {
    final url = Uri.parse('$moviesBaseUrl/list_movies.json?page=$page&limit=20');
    final response = await http.get(url);

    final data = _handleResponse(response);

    if (data['data'] != null && data['data']['movies'] != null) {
      final moviesJson = data['data']['movies'] as List;
      return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
