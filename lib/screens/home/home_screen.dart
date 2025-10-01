import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie/screens/home/profile_tab.dart';
import 'package:movie/screens/home/search_tab.dart';
import '../../core/colors_manger/colors.dart';
import 'explore_tab.dart';
import 'home_tab.dart';

class HomeScreenTab extends StatefulWidget {
  const HomeScreenTab({super.key});

  @override
  State<HomeScreenTab> createState() => _HomeScreenTabState();
}

class _HomeScreenTabState extends State<HomeScreenTab> {
  int _currentIndex = 0;

  void _setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late final List<Widget> _tabs = [
    HomeTab(onSeeMorePressed: () => _setIndex(2)),
    const SearchTab(),
    const ExploreTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 9.h),
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _setIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.grey,
            elevation: 0,
            selectedItemColor: AppColors.yellow,
            unselectedItemColor: AppColors.white,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
              BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            ],
          ),
        ),
      ),
    );
  }
}
