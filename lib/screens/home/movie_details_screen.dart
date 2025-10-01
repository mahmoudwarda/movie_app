import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie/screens/home/explore_tab.dart';
import '../../../../core/bottoms/buttons.dart';
import '../../../../core/colors_manger/colors.dart';
import '../../../../core/models/movie_model/movie_model.dart';
import '../../../../core/utils/api_service.dart';
import '../../../../core/widgets/movie_card.dart';
import '../../core/routes_manegar/routes.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  MovieModel? movie;
  List<MovieModel> similarMovies = [];
  bool isLoading = true;
  String error = '';
  bool isWatchListed = false;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails(widget.movieId);
  }

  @override
  void didUpdateWidget(covariant MovieDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movieId != widget.movieId) {
      fetchMovieDetails(widget.movieId);
    }
  }

  /// Fetch details + status + suggestions
  Future<void> fetchMovieDetails(int movieId) async {
    try {
      final data = await ApiService.getMovieDetails(movieId);
      final watchListStatus = await ApiService.isFavorite(movieId.toString());
      final suggestions = await ApiService.getMovieSuggestions(movieId);

      if (mounted) {
        setState(() {
          movie = data;
          isWatchListed = watchListStatus;
          similarMovies = suggestions;
          isLoading = false;
        });
      }

      if (data != null) {
        await ApiService.addToHistoryLocal(
          movieId: data.id.toString(),
          name: data.title,
          year: data.year.toString(),
          imageURL: data.largeCoverImage,
          rating: data.rating,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = "Failed to load movie details: ${e.toString()}";
          isLoading = false;
        });
      }
    }
  }

  /// Toggle add/remove favorite
  Future<void> toggleWatchListStatus() async {
    if (movie == null) return;
    bool success = false;
    String snackBarMessage = "";

    if (isWatchListed) {
      success = await ApiService.removeFavorite(movie!.id.toString());
      snackBarMessage =
      success ? "Movie removed from watch list" : "Failed to remove from watch list";
    } else {
      success = await ApiService.addFavorite(
        movieId: movie!.id.toString(),
        name: movie!.title,
        year: movie!.year.toString(),
        imageURL: movie!.largeCoverImage,
        rating: movie!.rating,
      );
      snackBarMessage =
      success ? "Movie added to watch list" : "Failed to add to watch list";
    }

    if (success && mounted) {
      setState(() => isWatchListed = !isWatchListed);
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            snackBarMessage,
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: success ? AppColors.grey : AppColors.red,
        ),
      );
  }

  /// Info Card (runtime, rating, year)
  Widget buildInfoCard(IconData icon, String text) {
    return Card(
      color: AppColors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        child: Row(
          children: [
            Icon(icon, color: AppColors.yellow, size: 18.sp),
            SizedBox(width: 5.w),
            Text(text, style: TextStyle(color: AppColors.white, fontSize: 14.sp)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.yellow))
          : error.isNotEmpty
          ? Center(
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.red, fontSize: 16.sp),
        ),
      )
          : movie == null
          ? Center(
        child: Text(
          "Movie not found",
          style: TextStyle(color: AppColors.white),
        ),
      )
          : Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.network(
            movie!.largeCoverImage,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.5),
            colorBlendMode: BlendMode.darken,
          ),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),

                      // Header (Back + Favorite)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.white,
                              size: 24.sp,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          IconButton(
                            icon: Icon(
                              isWatchListed
                                  ? Icons.bookmark_added
                                  : Icons.bookmark_add_outlined,
                              color: AppColors.white,
                              size: 24.sp,
                            ),
                            onPressed: toggleWatchListStatus,
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Play button
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.yellow.withOpacity(0.9),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(16.r),
                          child: Icon(
                            Icons.play_arrow,
                            color: AppColors.black,
                            size: 30.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Title
                      Text(
                        movie!.title,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Watch now button
                      Center(
                        child: CustomButton(
                          label: "Watch Now",
                          onPressed: () {},
                          backgroundColor: AppColors.red,
                          textColor: AppColors.white,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Info row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildInfoCard(Icons.access_time, "${movie!.runtime} min"),
                          buildInfoCard(Icons.star, "${movie!.rating}"),
                          buildInfoCard(Icons.calendar_today, "${movie!.year}"),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Description
                      // ✅ Description with See More button
                      Text(
                        movie!.descriptionFull.isNotEmpty
                            ? (movie!.descriptionFull.length > 150
                            ? movie!.descriptionFull.substring(0, 150) + "..."
                            : movie!.descriptionFull)
                            : "No summary available.",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Screenshots
                      if (movie!.screenshots.isNotEmpty) ...[
                        Text(
                          "Screenshots",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: 180.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: movie!.screenshots.length,
                            itemBuilder: (ctx, i) => Container(
                              width: 300.w,
                              margin: EdgeInsets.only(right: 12.w),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: FadeInImage.assetNetwork(
                                  placeholder: "assets/images/loading.gif",
                                  image: movie!.screenshots[i],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],

                      // Similar Movies
                      if (similarMovies.isNotEmpty) ...[
                        Text(
                          "You May Also Like",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: 220.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: similarMovies.length,
                            itemBuilder: (context, index) {
                              final suggestion = similarMovies[index];
                              return Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: MovieCard(
                                  movie: suggestion,
                                  width: 140.w,
                                  height: 220.h,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MovieDetailsScreen(
                                          movieId: suggestion.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],

                      // Cast
                      if (movie!.cast.isNotEmpty) ...[
                        Text(
                          "Cast",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: movie!.cast
                              .where((actor) =>
                          actor.name.isNotEmpty ||
                              actor.character.isNotEmpty ||
                              (actor.profilePath != null &&
                                  actor.profilePath!.isNotEmpty))
                              .length,
                          itemBuilder: (ctx, i) {
                            final validCast = movie!.cast.where((actor) =>
                            actor.name.isNotEmpty ||
                                actor.character.isNotEmpty ||
                                (actor.profilePath != null && actor.profilePath!.isNotEmpty)
                            ).toList();

                            final actor = validCast[i];

                            return Card(
                              color: AppColors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r)),
                              margin: EdgeInsets.only(bottom: 12.h),
                              child: Padding(
                                padding: EdgeInsets.all(8.r),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: SizedBox(
                                        width: 50.w,
                                        height: 50.h,
                                        child: (actor.profilePath != null &&
                                            actor.profilePath!.isNotEmpty)
                                            ? Image.network(
                                          actor.profilePath!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              "assets/images/image-.png",
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                            : Image.asset(
                                          "assets/images/image-.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            actor.name.isNotEmpty
                                                ? actor.name
                                                : "Unknown Actor",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            actor.character.isNotEmpty
                                                ? actor.character
                                                : "Unknown role",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 12.sp,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                      ],

                      // Genres
                      Text(
                        "Genres",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 8.w,
                        children: (movie!.genres.isNotEmpty
                            ? movie!.genres
                            : ["Unknown"])
                            .map(
                              (g) => Chip(
                            label: Text(g),
                            backgroundColor: AppColors.grey,
                            labelStyle: TextStyle(
                              color: AppColors.white,
                              fontSize: 12.sp,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 4.h),
                          ),
                        )
                            .toList(),
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
