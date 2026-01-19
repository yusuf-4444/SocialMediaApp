import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialLoginButton extends StatelessWidget {
  final String platform;
  final String imagePath;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double? iconSize;
  final double? fontSize;
  final double? height;

  const SocialLoginButton({
    super.key,
    required this.platform,
    required this.imagePath,
    required this.onPressed,
    this.backgroundColor,
    this.iconSize,
    this.fontSize,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: height ?? 48.h,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.white,
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            side: BorderSide(color: Colors.grey, width: 1.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: iconSize ?? 20.w,
                height: iconSize ?? 20.h,
              ),
              SizedBox(width: 8.w),
              Text(
                platform,
                style: TextStyle(
                  fontSize: fontSize ?? 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
