import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/colors_manger/colors.dart';
import '../../core/bottoms/buttons.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 35.r,
                  backgroundColor: Colors.blue.shade300,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/avatar.png",
                      width: 100.w,
                      height: 100.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "12",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Wish List",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 24.sp,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "10",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "History",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 24.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.h),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: "Edit Profile",
                    backgroundColor: Colors.yellow.shade700,
                    textColor: Colors.black,
                    onPressed: () {
                    },
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: CustomButton(
                    label: "Exit",
                    backgroundColor: AppColors.red,
                    onPressed: () {
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    print("Watch List clicked");
                  },
                  child: Column(
                    children: [
                      Icon(Icons.list,
                          color: Colors.yellow.shade700, size: 28.sp),
                      SizedBox(height: 6.h),
                      Text(
                        "Watch List",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    print("History clicked");
                  },
                  child: Column(
                    children: [
                      Icon(Icons.folder,
                          color: Colors.yellow.shade700, size: 28.sp),
                      SizedBox(height: 6.h),
                      Text(
                        "History",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Expanded(
              child: Center(
                child: Image.asset(
                  "assets/images/search.png",
                  width: 120.w,
                  height: 120.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
