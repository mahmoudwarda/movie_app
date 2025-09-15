class MovieModel {
  final String title;
  final double rating;
  final String mediumCoverImage;
  final int year;
  final List<String> genres;

  MovieModel({
    required this.title,
    required this.rating,
    required this.mediumCoverImage,
    required this.year,
    required this.genres,
  });
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json['title'] ?? 'No Title',
      rating: (json['rating'] ?? 0.0).toDouble(),
      mediumCoverImage: json['large_cover_image'] ?? '',
      year: json['year'] ?? 0,
      genres: List<String>.from(json['genres'] ?? []),
    );
  }
  }
