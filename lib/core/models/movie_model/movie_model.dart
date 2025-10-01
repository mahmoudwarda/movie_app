class MovieModel {
  final int id;
  final String title;
  final double rating;
  final String largeCoverImage;
  final String mediumCoverImage;
  final int year;
  final List<String> genres;
  final String descriptionFull;
  final int runtime;
  final List<String> screenshots;
  final List<CastModel> cast;

  MovieModel({
    required this.id,
    required this.title,
    required this.rating,
    required this.largeCoverImage,
    required this.mediumCoverImage,
    required this.year,
    required this.genres,
    required this.descriptionFull,
    required this.runtime,
    required this.screenshots,
    required this.cast,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      largeCoverImage: json['large_cover_image'] ?? '',
      mediumCoverImage: json['medium_cover_image'] ?? '',
      year: json['year'] ?? 0,
      genres: (json['genres'] as List<dynamic>?)
          ?.map((genre) => genre.toString())
          .toList() ??
          [],
      descriptionFull: json['description_full'] ?? '',
      runtime: json['runtime'] ?? 0,
      screenshots: (json['screenshots'] as List<dynamic>?)
          ?.map((s) => s.toString())
          .toList() ??
          [],
      cast: (json['cast'] as List<dynamic>?)
          ?.map((c) => CastModel.fromJson(c))
          .toList() ??
          [],
    );
  }

  MovieModel copyWith({
    int? id,
    String? title,
    double? rating,
    String? largeCoverImage,
    String? mediumCoverImage,
    int? year,
    List<String>? genres,
    String? descriptionFull,
    int? runtime,
    List<String>? screenshots,
    List<CastModel>? cast,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      rating: rating ?? this.rating,
      largeCoverImage: largeCoverImage ?? this.largeCoverImage,
      mediumCoverImage: mediumCoverImage ?? this.mediumCoverImage,
      year: year ?? this.year,
      genres: genres ?? this.genres,
      descriptionFull: descriptionFull ?? this.descriptionFull,
      runtime: runtime ?? this.runtime,
      screenshots: screenshots ?? this.screenshots,
      cast: cast ?? this.cast,
    );
  }
}

class CastModel {
  final String name;
  final String character;
  final String? profilePath;

  CastModel({
    required this.name,
    required this.character,
    this.profilePath,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'] != null
          ? "https://image.tmdb.org/t/p/w200${json['profile_path']}"
          : null,
    );
  }
}
