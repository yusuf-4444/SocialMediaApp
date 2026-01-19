import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:social_media_app/core/utils/app_colors.dart';
import 'package:social_media_app/features/auth/services/auth_services.dart';
import 'package:social_media_app/features/home/home_cubit/home_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _textController = TextEditingController();
  String? _selectedImagePath;
  String? _selectedVideoPath;
  late User? user;

  @override
  void initState() {
    super.initState();
    final AuthServicesImpl authServices = AuthServicesImpl();
    user = authServices.fetchCurrentUser();
  }

  void _showMediaBottomSheet() {
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
                  _openCamera();
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
                  _pickImage();
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
                  _pickVideo();
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

  void _openCamera() {
    // TODO: Implement camera functionality
    print('Open Camera');
  }

  void _pickImage() {
    // TODO: Implement image picker
    print('Pick Image');
  }

  void _pickVideo() {
    // TODO: Implement video picker
    print('Pick Video');
  }

  void _createPost() {
    // TODO: Implement create post logic
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please write something')));
      return;
    }
    BlocProvider.of<HomeCubit>(
      context,
    ).createPost(_textController.text, _selectedImagePath ?? '');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
          TextButton(
            onPressed: _createPost,
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
              // User info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.babyBlue,
                  ),
                  Gap(12.w),
                  Text(
                    'User Name',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),

              Gap(20.h),

              // Text input
              TextField(
                controller: _textController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: "What's on your head?",
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

              // Selected media preview (if any)
              if (_selectedImagePath != null || _selectedVideoPath != null)
                Container(
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          _selectedImagePath != null
                              ? Icons.image
                              : Icons.videocam,
                          size: 50.sp,
                          color: Colors.grey[400],
                        ),
                      ),
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: AppColors.black,
                            size: 24.sp,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedImagePath = null;
                              _selectedVideoPath = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              Gap(20.h),

              // Add media button
              InkWell(
                onTap: _showMediaBottomSheet,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        color: AppColors.babyBlue,
                        size: 24.sp,
                      ),
                      Gap(12.w),
                      Text(
                        'Add Photo or Video',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
