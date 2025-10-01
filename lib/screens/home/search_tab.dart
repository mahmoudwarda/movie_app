import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/colors_manger/colors.dart';
import '../../core/models/movie_model/movie_model.dart';
import '../../core/utils/api_service.dart';
import '../../core/widgets/movie_card.dart';
import 'movie_details_screen.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  List<MovieModel> _movies = [];
  bool _isLoading = false;
  String _error = "";

  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() {
          _movies = [];
          _error = "";
        });
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _error = "";
    });

    try {
      final results = await ApiService.searchMovies(query: query);
      setState(() {
        if (results.isEmpty) {
          _error = "No movies found for \"$query\".";
          _movies = [];
        } else {
          _movies = results;
          _error = "";
        }
      });
    } catch (e) {
      setState(() {
        _error = "Failed to search movies. Please try again.";
        _movies = [];
        print("Search error: $e");
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: AppColors.white, fontSize: 16.sp),
                  textInputAction: TextInputAction.search,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: AppColors.white, fontSize: 16.sp),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 8.w, right: 4.w),
                      child: Icon(Icons.search, color: AppColors.white, size: 24.sp),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error.isNotEmpty
                  ? Center(
                child: Text(
                  _error,
                  style: TextStyle(color: AppColors.white, fontSize: 14.sp),
                ),
              )
                  : _movies.isEmpty
                  ? Center(
                child: Image.asset(
                  "assets/images/search.png",
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.contain,
                ),
              )
                  : GridView.builder(
                padding: EdgeInsets.all(8.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                  childAspectRatio: 0.7,
                ),
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieDetailsScreen(movieId: movie.id),
                        ),
                      );
                    },
                    child: MovieCard(movie: movie),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
