import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:social_media_app/core/utils/app_colors.dart';
import 'package:social_media_app/features/home/home_cubit/home_cubit.dart';

class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    return SizedBox(
      height: 100.h,
      child: BlocBuilder<HomeCubit, HomeState>(
        bloc: homeCubit,
        buildWhen: (previous, current) =>
            current is StoriesLoaded || current is StoriesLoading,
        builder: (context, state) {
          if (state is StoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StoriesLoaded) {
            return Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35.r,
                        backgroundColor: AppColors.babyBlue,
                        child: const Icon(Icons.add, color: AppColors.white),
                      ),
                      Gap(8.h),
                      Text(
                        "Your Story",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.babyBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: state.stories.length,
                  itemBuilder: (context, index) {
                    final story = state.stories[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35.r,
                            backgroundColor: AppColors.babyBlue,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30.r),
                              child: Image.network(
                                story.imageUrl,
                                fit: BoxFit.cover,
                                height: 60.h,
                                width: 55.w,
                              ),
                            ),
                          ),
                          Gap(8.h),
                          Text(
                            story.name!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.babyBlue,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      CircleAvatar(radius: 35.r),
                      Gap(8.h),
                      Text(
                        "Your Story",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.babyBlue,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    CircleAvatar(radius: 35.r),
                    Gap(8.h),
                    Text(
                      "User $index",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.babyBlue,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
