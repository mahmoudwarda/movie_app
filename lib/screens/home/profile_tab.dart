import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/api_service.dart';
import '../../core/colors_manger/colors.dart';
import '../../core/bottoms/buttons.dart';
import '../../core/models/user_model/user_model.dart';
import '../auth/update_profile_screen.dart';
import '../../core/models/movie_model/movie_model.dart';
import '../../core/widgets/movie_card.dart';
import 'movie_details_screen.dart';
import '../auth/login_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ProfileModel? userProfile;
  int historyCount = 0;
  bool isLoading = true;
  List<MovieModel> watchListMovies = [];
  bool _isInitialLoad = true;

  final List<String> _avatars = List.generate(
    6,
        (index) => "assets/images/av_${index + 1}.png",
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialLoad) {
      _fetchData();
      _isInitialLoad = false;
    }
  }

  Future<void> _fetchData({bool forceRefresh = false}) async {
    if (!forceRefresh) setState(() => isLoading = true);

    try {
      final profile = await ApiService.getProfile();
      final watchlist = await ApiService.getFavorites();
      final history = await ApiService.getHistoryLocal();

      if (mounted) {
        setState(() {
          userProfile = profile;
          watchListMovies = watchlist;
          historyCount = history.length;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      debugPrint("❌ Error fetching profile data: $e");
    }
  }

  Widget _buildStat(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 19.h),
        Text(
          count,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 24.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar({double radius = 35}) {
    String avatarPath = "assets/images/av_1.png";
    if (userProfile != null && userProfile!.avaterId > 0 && userProfile!.avaterId <= _avatars.length) {
      avatarPath = _avatars[userProfile!.avaterId - 1];
    }

    return CircleAvatar(
      radius: radius.r,
      backgroundColor: Colors.blue.shade300,
      child: ClipOval(
        child: Image.asset(
          avatarPath,
          fit: BoxFit.cover,
          width: radius * 2.w,
          height: radius * 2.h,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.person, color: AppColors.black, size: radius.sp);
          },
        ),
      ),
    );
  }

  Widget _buildWatchlistGrid(List<MovieModel> movies) {
    if (movies.isEmpty) {
      return Container();
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieCard(
          movie: movie,
          width: 160.w,
          height: 240.h,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailsScreen(movieId: movie.id),
              ),
            ).then((_) => _fetchData(forceRefresh: true));
          },
        );
      },
    );
  }

  Widget _buildHistoryList() {
    return FutureBuilder<List<MovieModel>>(
      future: ApiService.getHistoryLocal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: AppColors.yellow));
        }
        if (snapshot.hasError) {
          return Container();
        }

        final historyList = snapshot.data ?? [];
        return _buildWatchlistGrid(historyList);
      },
    );
  }

  void _logout() async {
    await LocalStorage.clearToken();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  Widget _buildProfileHeaderContent() {
    if (userProfile == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(radius: 40),
            SizedBox(width: 20.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStat(watchListMovies.length.toString(), "Wish List"),
                  SizedBox(width: 20.w),
                  _buildStat(historyCount.toString(), "History"),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userProfile?.name ?? "Guest User",
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(height: 30.h),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomButton(
                label: "Edit Profile",
                backgroundColor: Colors.yellow.shade700,
                textColor: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UpdateProfileScreen(),
                    ),
                  ).then((_) => _fetchData(forceRefresh: true));
                },
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              flex: 1,
              child: CustomButton(
                label: "Exit",
                backgroundColor: AppColors.red,
                textColor: Colors.white,
                onPressed: _logout,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabRow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTabButton(
              label: "Watch List",
              icon: Icons.list,
              index: 0,
            ),
            _buildTabButton(
              label: "History",
              icon: Icons.folder,
              index: 1,
            ),
          ],
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildTabButton({
    required String label,
    required IconData icon,
    required int index,
  }) {
    final isSelected = _tabController.index == index;
    final color = isSelected
        ? Colors.yellow.shade700
        : AppColors.white.withOpacity(0.7);

    return InkWell(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Column(
        children: [
          Icon(icon, color: color, size: 28.sp),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3.h,
            width: isSelected ? 60.w : 0,
            decoration: BoxDecoration(
              color: isSelected ? Colors.yellow.shade700 : Colors.transparent,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color topBackgroundColor = Color(0xFF1C1C1C);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: isLoading && userProfile == null
          ? Center(child: CircularProgressIndicator(color: AppColors.yellow))
          : Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: topBackgroundColor,
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeaderContent(),
                    SizedBox(height: 20.h),
                    _buildTabRow(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/search.png',
                    width: 150.w,
                    height: 150.h,
                    fit: BoxFit.contain,
                  ),
                ),
                TabBarView(
                  controller: _tabController,
                  children: [
                    _buildWatchlistGrid(watchListMovies),
                    _buildHistoryList(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
