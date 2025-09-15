import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/colors_manger/colors.dart';
import '../../core/widgets/custom_bottom_nav.dart';
import '../../core/widgets/movie_card.dart';
import '../../core/utils/api_service.dart';
import '../../core/models/movie_model/movie_model.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _carouselIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.65);

  List<MovieModel> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  void fetchMovies() async {
    try {
      final result = await ApiService.getMovies();
      setState(() {
        movies = result;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching movies: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (movies.isEmpty) {
      return const Center(child: Text("No movies found"));
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Background
          if (movies.isNotEmpty)
            SizedBox.expand(
              child: Image.network(
                movies[_carouselIndex].mediumCoverImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.black),
              ),
            )
          else
            Container(color: Colors.black),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.black.withOpacity(0.9),
                  AppColors.black.withOpacity(0.7),
                  AppColors.black.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.02),

                    // Logo/Title
                    Center(
                      child: Image.asset(
                        'assets/images/available.png',
                        height: 93.h,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Carousel
                    SizedBox(
                      height: screenHeight * 0.40,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: movies.length,
                        onPageChanged: (index) {
                          setState(() {
                            _carouselIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Center(
                            child: MovieCard(
                              movie: movies[index],
                              width: 180.w,
                              height: 280.h,
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 10.h),



                    SizedBox(height: 20.h),

                    // Watch Now Image
                    Center(
                      child: Image.asset(
                        'assets/images/watch_now.png',
                        height: 146.h,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Action Section
                    const SectionHeader(title: "Action"),
                    SizedBox(height: 12.h),
                    SizedBox(
                      height: 220.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: MovieCard(
                              movie: movies[index],
                              width: 150.w,
                              height: 220.h,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
