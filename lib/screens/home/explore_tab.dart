import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/colors_manger/colors.dart';
import '../../../core/utils/api_service.dart';
import '../../../core/models/movie_model/movie_model.dart';
import 'movie_details_screen.dart'; // ✅ import your details screen

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final List<String> _categories = [
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Sci-Fi',
    'Romance',
    'Animation',
    'Documentary',
  ];

  int _selectedIndex = 0;
  List<MovieModel> _movies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMovies(_categories[_selectedIndex]); // load first category
  }

  Future<void> _fetchMovies(String category) async {
    setState(() => _isLoading = true);
    final movies = await ApiService.searchMovies(query: category);
    setState(() {
      _movies = movies;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // Categories
              SizedBox(
                height: 40.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final bool isSelected = _selectedIndex == index;
                    return Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _selectedIndex = index);
                          _fetchMovies(_categories[index]);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isSelected
                              ? AppColors.yellow
                              : Colors.transparent,
                          side: BorderSide(color: AppColors.yellow, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                        ),
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.black
                                : AppColors.yellow,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20.h),

              // Movies List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _movies.isEmpty
                    ? const Center(
                  child: Text(
                    "No movies found",
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _movies.length,
                  itemBuilder: (context, index) {
                    final movie = _movies[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MovieDetailsScreen(
                              movieId: movie.id, // ✅ مرر الـ id هنا
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(12.r),
                              child: Image.network(
                                movie.mediumCoverImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            movie.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
