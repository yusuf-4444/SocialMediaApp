import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:social_media_app/core/utils/app_colors.dart';
import 'package:social_media_app/features/home/home_cubit/home_cubit.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _textController = TextEditingController();
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeCubit>(context).fetchUserData();
  }

  void _showMediaBottomSheet(HomeCubit cubit) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Gap(20.h),

              // Camera Option
              _buildBottomSheetOption(
                icon: Icons.camera_alt,
                iconColor: Colors.blue,
                title: 'Camera',
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickImageFromCamera();
                },
              ),

              Gap(12.h),

              // Photo Option
              _buildBottomSheetOption(
                icon: Icons.photo_library,
                iconColor: Colors.green,
                title: 'Add A Photo',
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickImageFromGallery();
                },
              ),

              Gap(12.h),

              // Video Option
              _buildBottomSheetOption(
                icon: Icons.videocam,
                iconColor: Colors.red,
                title: 'Take A Video',
                onTap: () {
                  Navigator.pop(context);
                  cubit.pickVideoFromGallery();
                },
              ),

              Gap(20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            Gap(16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createPost(HomeCubit cubit) async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please write something')));
      return;
    }

    setState(() => _isPosting = true);

    final imagePath = cubit.pickedImage?.path ?? '';
    await cubit.createPost(_textController.text.trim(), imagePath);

    setState(() => _isPosting = false);
  }

  void _removeMedia(HomeCubit cubit) {
    setState(() {
      cubit.pickedImage = null;
      cubit.pickedVideo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is PostCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is PostCreatedError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is ImagePickingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is VideoPickingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final cubit = BlocProvider.of<HomeCubit>(context);

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: AppColors.black, size: 24.sp),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Create a Post',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            centerTitle: true,
            actions: [
              if (_isPosting)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                TextButton(
                  onPressed: () => _createPost(cubit),
                  child: Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info section
                  _buildUserInfoSection(state),

                  Gap(20.h),

                  // Text input
                  TextField(
                    controller: _textController,
                    maxLines: 8,
                    enabled: !_isPosting,
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16.sp, color: AppColors.black),
                  ),

                  Gap(20.h),

                  // Selected media preview
                  if (cubit.pickedImage != null || cubit.pickedVideo != null)
                    _buildMediaPreview(cubit),

                  if (cubit.pickedImage != null || cubit.pickedVideo != null)
                    Gap(20.h),

                  // Add media button
                  if (cubit.pickedImage == null && cubit.pickedVideo == null)
                    _buildAddMediaButton(cubit),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfoSection(HomeState state) {
    if (state is FetchingUserData) {
      return Row(
        children: [
          CircleAvatar(radius: 20.r, backgroundColor: AppColors.babyBlue),
          Gap(12.w),
          Container(
            width: 100.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ],
      );
    }

    if (state is UserFetchedError) {
      return Row(
        children: [
          CircleAvatar(radius: 20.r, backgroundColor: AppColors.babyBlue),
          Gap(12.w),
          Text(
            'Error loading user',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: AppColors.babyBlue,
          backgroundImage: state is UserFetched && state.user.imageUrl != null
              ? NetworkImage(state.user.imageUrl!)
              : null,
          child: state is UserFetched && state.user.imageUrl == null
              ? Text(
                  state.user.name.isNotEmpty
                      ? state.user.name[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                )
              : null,
        ),
        Gap(12.w),
        Text(
          state is UserFetched ? state.user.name : 'User',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildMediaPreview(HomeCubit cubit) {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: cubit.pickedImage != null
                ? Image.file(
                    cubit.pickedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam,
                          size: 50.sp,
                          color: Colors.grey[600],
                        ),
                        Gap(8.h),
                        Text(
                          'Video selected',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.close, color: AppColors.white, size: 20.sp),
                onPressed: () => _removeMedia(cubit),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMediaButton(HomeCubit cubit) {
    return InkWell(
      onTap: _isPosting ? null : () => _showMediaBottomSheet(cubit),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: _isPosting ? Colors.grey[400] : AppColors.babyBlue,
              size: 24.sp,
            ),
            Gap(12.w),
            Text(
              'Add Photo or Video',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: _isPosting ? Colors.grey[400] : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
