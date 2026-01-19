import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:social_media_app/core/router/app_routes.dart';
import 'package:social_media_app/core/utils/app_colors.dart';
import 'package:social_media_app/core/utils/assets.dart';
import 'package:social_media_app/features/home/home_cubit/home_cubit.dart';

class CustomPostCard extends StatelessWidget {
  const CustomPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.post, arguments: true).then((
          value,
        ) {
          if (value == true) {
            BlocProvider.of<HomeCubit>(context).fetchPosts();
          }
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsImagesPostBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 25.r),
                  Gap(12.w),
                  Text(
                    "What's on your head?",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff00000080).withOpacity(0.50),
                    ),
                  ),
                ],
              ),
              Gap(24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.photo, color: AppColors.babyBlue, size: 30.sp),
                      Gap(5.w),
                      Text(
                        "photo",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                    child: VerticalDivider(
                      color: Color(0xff00000080).withOpacity(0.50),
                      thickness: 1.w,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.video_call,
                        color: AppColors.babyBlue,
                        size: 30.sp,
                      ),
                      Gap(5.w),
                      Text(
                        "video",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(12.h),
            ],
          ),
        ),
      ),
    );
  }
}
