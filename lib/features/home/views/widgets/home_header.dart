import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/core/utils/app_colors.dart';
import 'package:social_media_app/core/utils/assets.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(Assets.assetsImagesLogo, width: 220.w, height: 100.h),
        Spacer(),
        IconButton(
          icon: Icon(Icons.search, color: AppColors.black, size: 30.sp),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: AppColors.black,
            size: 30.sp,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
