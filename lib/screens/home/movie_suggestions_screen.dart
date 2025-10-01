import 'package:flutter/material.dart';
import '../../../core/utils/api_service.dart';
import '../../../core/models/movie_model/movie_model.dart';
import 'movie_details_screen.dart';

class MovieSuggestionsScreen extends StatefulWidget {
  final int movieId;

  const MovieSuggestionsScreen({super.key, required this.movieId});

  @override
  State<MovieSuggestionsScreen> createState() => _MovieSuggestionsScreenState();
}

class _MovieSuggestionsScreenState extends State<MovieSuggestionsScreen> {
  List<MovieModel> suggestions = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchSuggestions();
  }

  Future<void> fetchSuggestions() async {
    try {
      final data = await ApiService.getMovieSuggestions(widget.movieId);
      setState(() {
        suggestions = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Failed to load suggestions: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Movie Suggestions"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.yellow),
      )
          : error.isNotEmpty
          ? Center(
        child: Text(
          error,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      )
          : suggestions.isEmpty
          ? const Center(
        child: Text(
          "No suggestions available",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final movie = suggestions[index];
          return ListTile(
            leading: movie.mediumCoverImage.isNotEmpty
                ? Image.network(
              movie.mediumCoverImage,
              width: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 60,
                color: Colors.grey,
                child: const Icon(Icons.broken_image, color: Colors.white),
              ),
            )
                : Container(
              width: 60,
              color: Colors.grey,
              child: const Icon(Icons.broken_image, color: Colors.white),
            ),
            title: Text(
              movie.title,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "Rating: ${movie.rating.toStringAsFixed(1)}",
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailsScreen(movieId: movie.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
