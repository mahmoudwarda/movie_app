import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie_model/movie_model.dart';
import '../models/user_model/user_model.dart';

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
  final dynamic message;
  final String? token;

  AuthResponse({required this.success, required this.message, this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    bool parsedSuccess = false;
    final rawSuccess = json['success'];
    if (rawSuccess is bool) parsedSuccess = rawSuccess;
    else if (rawSuccess is String) parsedSuccess = rawSuccess.toLowerCase() == 'true';
    else if (json['message']?.toString().toLowerCase().contains('success') == true) parsedSuccess = true;

    String? token;
    if (json['token'] != null) token = json['token'];
    else if (json['data'] != null && json['data'] is String) token = json['data'];

    return AuthResponse(success: parsedSuccess, message: json['message'], token: token);
  }

  String get parsedMessage {
    if (message == null) return "Unknown error";
    if (message is List && message.isNotEmpty) return message.first.toString();
    if (message is String) return message;
    return message.toString();
  }
}

class ApiService {
  static const String moviesBaseUrl = 'https://yts.mx/api/v2';
  static const String authBaseUrl = 'https://route-movie-apis.vercel.app';
  static const String tmdbBaseUrl = "https://api.themoviedb.org/3";
  static const String tmdbApiKey = "7b2e6fb13f7eec9d59180f292c6de565";

  static dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) return data;

    String errorMessage = 'Something went wrong';
    if (data is Map<String, dynamic> && data['message'] != null) {
      if (data['message'] is List && data['message'].isNotEmpty) errorMessage = data['message'][0].toString();
      else if (data['message'] is String) errorMessage = data['message'];
    }

    throw ApiException(errorMessage);
  }

  static Future<AuthResponse?> login({required String email, required String password}) async {
    try {
      final url = Uri.parse('$authBaseUrl/auth/login');
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email, "password": password}));
      final data = _handleResponse(response);
      final auth = AuthResponse.fromJson(data);
      if (auth.success && auth.token != null) {
        await LocalStorage.saveToken(auth.token!);
        await getProfile(forceFetch: true);
      }
      return auth;
    } catch (e) {
      print("Login failed: $e");
      return null;
    }
  }

  static Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required int avaterId,
  }) async {
    try {
      final url = Uri.parse('$authBaseUrl/auth/register');
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": name,
            "email": email,
            "password": password,
            "confirmPassword": confirmPassword,
            "phone": phone,
            "avaterId": avaterId,
          }));
      final data = _handleResponse(response);
      return AuthResponse.fromJson(data);
    } catch (e) {
      print("Register failed: $e");
      rethrow;
    }
  }

  static Future<String?> resetPassword({required String oldPassword, required String newPassword}) async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null) throw ApiException("User not logged in");
      final url = Uri.parse('$authBaseUrl/auth/reset-password');
      final response = await http.patch(url,
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
          body: jsonEncode({"oldPassword": oldPassword, "newPassword": newPassword}));
      final data = _handleResponse(response);
      return data['message']?.toString() ?? "Password reset successful";
    } catch (e) {
      print("Reset password failed: $e");
      return null;
    }
  }

  static Future<ProfileModel?> getProfile({bool forceFetch = false}) async {
    if (!forceFetch) {
      final localProfile = await ProfileModel.getLocalProfile();
      if (localProfile != null) return localProfile;
    }
    try {
      final token = await LocalStorage.getToken();
      if (token == null) throw ApiException("User not logged in");
      final url = Uri.parse('$authBaseUrl/profile');
      final response = await http.get(url, headers: {"Authorization": "Bearer $token"});
      final data = _handleResponse(response);
      if (data['data'] != null) {
        final profile = ProfileModel.fromJson(data['data']);
        await ProfileModel.saveLocalProfile(profile);
        return profile;
      }
    } catch (e) {
      print("Get profile failed: $e");
    }
    return null;
  }

  static Future<String?> updateProfile({String? email, String? name, String? phone, int? avaterId}) async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null) throw ApiException("User not logged in");
      final url = Uri.parse('$authBaseUrl/profile');
      final body = <String, dynamic>{};
      if (email != null) body["email"] = email;
      if (name != null) body["name"] = name;
      if (phone != null) body["phone"] = phone;
      if (avaterId != null) body["avaterId"] = avaterId;

      final response = await http.patch(url,
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
          body: jsonEncode(body));
      final data = _handleResponse(response);
      await getProfile(forceFetch: true);
      return data['message']?.toString() ?? "Profile updated successfully";
    } catch (e) {
      print("Update profile failed: $e");
      return null;
    }
  }

  static Future<String?> deleteProfile() async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null) throw ApiException("User not logged in");
      final url = Uri.parse('$authBaseUrl/profile');
      final response = await http.delete(url, headers: {"Authorization": "Bearer $token"});
      final data = _handleResponse(response);
      await LocalStorage.clearToken();
      await ProfileModel.clearLocalProfile();
      return data['message']?.toString() ?? "Profile deleted successfully";
    } catch (e) {
      print("Delete profile failed: $e");
      return null;
    }
  }

  static Future<List<MovieModel>> getMovies({int page = 1}) async {
    try {
      final url = Uri.parse('$moviesBaseUrl/list_movies.json?page=$page&limit=20');
      final response = await http.get(url);
      final data = _handleResponse(response);
      if (data['data']?['movies'] != null) {
        return (data['data']['movies'] as List).map((json) => MovieModel.fromJson(json)).toList();
      }
    } catch (e) {
      print("Get movies failed: $e");
    }
    return [];
  }

  static Future<List<MovieModel>> searchMovies({required String query}) async {
    try {
      final url = Uri.parse('$moviesBaseUrl/list_movies.json?query_term=$query');
      final response = await http.get(url);
      final data = _handleResponse(response);
      if (data['data']?['movies'] != null) {
        return (data['data']['movies'] as List).map((json) => MovieModel.fromJson(json)).toList();
      }
    } catch (e) {
      print("Search movies failed: $e");
    }
    return [];
  }

  static Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
    try {
      final url = Uri.parse('$moviesBaseUrl/movie_suggestions.json?movie_id=$movieId');
      final response = await http.get(url);
      final data = _handleResponse(response);
      if (data['data']?['movies'] != null) {
        return (data['data']['movies'] as List).map((json) => MovieModel.fromJson(json)).toList();
      }
    } catch (e) {
      print("Get movie suggestions failed: $e");
    }
    return [];
  }

  static Future<MovieModel?> getMovieDetails(int movieId, {String? tmdbId}) async {
    MovieModel? movie;

    try {
      final ytsResponse = await http.get(Uri.parse(
          '$moviesBaseUrl/movie_details.json?movie_id=$movieId&with_images=true&with_cast=true'));
      final ytsData = _handleResponse(ytsResponse);
      if (ytsData['data']?['movie'] != null) {
        movie = MovieModel.fromJson(ytsData['data']['movie']);
      }
    } catch (e) {
      print("YTS fetch failed: $e");
    }

    try {
      String tmdbUrl = '';
      if (tmdbId != null) {
        tmdbUrl = '$tmdbBaseUrl/movie/$tmdbId?api_key=$tmdbApiKey&append_to_response=images,credits';
      } else if (movie != null) {
        final searchUrl =
            '$tmdbBaseUrl/search/movie?api_key=$tmdbApiKey&query=${Uri.encodeComponent(movie.title)}';
        final searchResponse = await http.get(Uri.parse(searchUrl));
        final searchData = jsonDecode(searchResponse.body);
        if (searchData['results'] != null && searchData['results'].isNotEmpty) {
          tmdbId = searchData['results'][0]['id'].toString();
          tmdbUrl =
          '$tmdbBaseUrl/movie/$tmdbId?api_key=$tmdbApiKey&append_to_response=images,credits';
        }
      }

      if (tmdbUrl.isNotEmpty) {
        final tmdbResponse = await http.get(Uri.parse(tmdbUrl));
        final tmdbData = jsonDecode(tmdbResponse.body);

        if (movie != null) {
          String updatedDescription = tmdbData['overview'] ?? movie.descriptionFull;

          List<String> updatedScreenshots = movie.screenshots;
          if (tmdbData['images']?['backdrops'] != null) {
            updatedScreenshots = (tmdbData['images']['backdrops'] as List)
                .map((img) => 'https://image.tmdb.org/t/p/original${img['file_path']}')
                .toList();
          }

          List<CastModel> updatedCast = movie.cast;
          if (tmdbData['credits']?['cast'] != null) {
            updatedCast = (tmdbData['credits']['cast'] as List)
                .map((c) => CastModel.fromJson(c))
                .toList();
          }

          movie = movie.copyWith(
            descriptionFull: updatedDescription,
            screenshots: updatedScreenshots,
            cast: updatedCast,
          );
        }
      }
    } catch (e) {
      print("TMDB fetch failed: $e");
    }

    return movie;
  }

  static Future<List<MovieModel>> getFavorites() async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null) return [];
      final url = Uri.parse('$authBaseUrl/favorites/all');
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
      });
      final data = _handleResponse(response);

      if (data['data'] is List) {
        return (data['data'] as List)
            .map((json) => MovieModel(
          id: int.tryParse(json['movieId'].toString()) ?? 0,
          title: json['name'] ?? '',
          rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 0.0,
          largeCoverImage: json['imageURL'] ?? '',
          mediumCoverImage: json['imageURL'] ?? '',
          year: int.tryParse(json['year'].toString()) ?? 0,
          genres: [],
          descriptionFull: '',
          runtime: 0,
          screenshots: [],
          cast: [],
        ))
            .toList();
      }
    } catch (e) {
      print("Get favorites failed: $e");
    }
    return [];
  }

  static Future<bool> isFavorite(String movieId) async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null) return false;
      final url = Uri.parse('$authBaseUrl/favorites/is-favorite/$movieId');
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
      });
      final data = _handleResponse(response);
      if (data['data'] is bool) return data['data'];
    } catch (e) {
      print("Check favorite failed: $e");
    }
    return false;
  }

  static Future<bool> addFavorite({
    required String movieId,
    required String name,
    required String year,
    required String imageURL,
    required double rating,
  }) async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null) throw ApiException("User not logged in");

      final url = Uri.parse('$authBaseUrl/favorites/add');
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            "movieId": movieId,
            "name": name,
            "rating": rating,
            "imageURL": imageURL,
            "year": year
          }));
      _handleResponse(response);
      return true;
    } catch (e) {
      print("Add favorite failed: $e");
      return false;
    }
  }

  static Future<bool> removeFavorite(String movieId) async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null) return false;
      final url = Uri.parse('$authBaseUrl/favorites/remove/$movieId');
      final response = await http.delete(url, headers: {
        "Authorization": "Bearer $token"
      });
      _handleResponse(response);
      return true;
    } catch (e) {
      print("Remove favorite failed: $e");
      return false;
    }
  }

  static Future<void> addToHistoryLocal({
    required String movieId,
    required String name,
    required String year,
    required String imageURL,
    required double rating,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = prefs.getStringList('history') ?? [];

    historyList.removeWhere((e) {
      final data = jsonDecode(e);
      return data['movieId'] == movieId;
    });

    historyList.add(jsonEncode({
      'movieId': movieId,
      'name': name,
      'year': year,
      'imageURL': imageURL,
      'rating': rating,
    }));

    await prefs.setStringList('history', historyList);
  }

  static Future<List<MovieModel>> getHistoryLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = prefs.getStringList('history') ?? [];
    return historyList.map((e) {
      final data = jsonDecode(e);
      return MovieModel(
        id: int.tryParse(data['movieId'].toString()) ?? 0,
        title: data['name'] ?? '',
        rating: (data['rating'] as num).toDouble(),
        largeCoverImage: data['imageURL'] ?? '',
        mediumCoverImage: data['imageURL'] ?? '',
        year: int.tryParse(data['year'].toString()) ?? 0,
        genres: [],
        descriptionFull: '',
        runtime: 0,
        screenshots: [],
        cast: [],
      );
    }).toList();
  }
}