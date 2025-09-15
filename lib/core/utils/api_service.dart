import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model/movie_model.dart';

class ApiService {
  static const String baseUrl = 'https://yts.mx/api/v2';

  static Future<List<MovieModel>> getMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/list_movies.json?limit=50'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final moviesJson = data['data']['movies'] as List;

      if (moviesJson.isNotEmpty && moviesJson[0]['runtime'] == 0) {
        return moviesJson.skip(1).map((json) => MovieModel.fromJson(json)).toList();
      }

      return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies: ${response.statusCode}');
    }
  }
}