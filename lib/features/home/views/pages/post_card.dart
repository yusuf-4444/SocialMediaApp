import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:social_media_app/core/utils/app_colors.dart';
import 'package:social_media_app/features/home/models/posts_model.dart';

class PostCard extends StatelessWidget {
  final PostsModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user info
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.babyBlue,
                  backgroundImage:
                      post.userImage != null && post.userImage!.isNotEmpty
                      ? NetworkImage(post.userImage!)
                      : null,
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.name!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        _formatTime(post.createdAt),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_horiz,
                    color: AppColors.black,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),

          // Post text
          if (post.text != null && post.text!.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                post.text!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ),

          if (post.text != null && post.text!.isNotEmpty) Gap(12.h),

          // Post image
          if (post.imagePost != null && post.imagePost!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              child: Image.network(
                post.imagePost!,
                width: double.infinity,
                height: 250.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 250.h,
                    color: Colors.grey[900],
                    child: const Icon(Icons.broken_image, size: 50),
                  );
                },
              ),
            ),

          Gap(8.h),

          // Interaction buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              children: [
                // Like button
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      color: AppColors.black,
                      size: 20.sp,
                    ),
                    Gap(6.w),
                    Text(
                      _formatCount(post.likes?.length ?? 0),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),

                Gap(24.w),

                // Comment button
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: AppColors.black,
                      size: 20.sp,
                    ),
                    Gap(6.w),
                    Text(
                      '135', // You can add comments count to the model
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Share button
                Icon(Icons.share_outlined, color: AppColors.black, size: 20.sp),

                Gap(16.w),

                // Bookmark button
                Icon(
                  Icons.bookmark_border,
                  color: AppColors.black,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return createdAt;
    }
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
