import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/core/router/app_routes.dart';
import 'package:social_media_app/core/utils/assets.dart';
import 'package:social_media_app/features/auth/auth_cubit/auth_cubit.dart';
import 'package:social_media_app/features/auth/views/widgets/custom_button.dart';
import 'package:social_media_app/features/auth/views/widgets/custom_text_field.dart';
import 'package:social_media_app/features/auth/views/widgets/social_login_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize ScreenUtil once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScreenUtil.init(
        context,
        designSize: const Size(375, 812), // iPhone 13 size
      );
    });
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      BlocProvider.of<AuthCubit>(context).registerWithEmailAndPassword(
        _emailPhoneController.text,
        _passwordController.text,
        _fullNameController.text,
      );
    }
  }

  void _handleGoogleSignIn() {
    // Implement Google sign in
  }

  void _handleMicrosoftSignIn() {
    // Implement Microsoft sign in
  }

  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // Fields
              CustomTextField(
                label: 'Your Full Name',
                hintText: 'Type your name',
                controller: _fullNameController,
                labelFontSize: 14.sp,
                hintFontSize: 14.sp,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),

              CustomTextField(
                label: 'Email/Phone',
                hintText: 'Type your email/phone',
                controller: _emailPhoneController,
                keyboardType: TextInputType.emailAddress,
                labelFontSize: 14.sp,
                hintFontSize: 14.sp,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email or phone';
                  }
                  return null;
                },
              ),

              CustomTextField(
                label: 'Password',
                hintText: 'Type your password',
                isPassword: true,
                controller: _passwordController,
                labelFontSize: 14.sp,
                hintFontSize: 14.sp,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              CustomTextField(
                label: 'Confirm Password',
                hintText: 'Retype your password',
                isPassword: true,
                controller: _confirmPasswordController,
                labelFontSize: 14.sp,
                hintFontSize: 14.sp,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24.h),

              // Sign Up Button
              BlocConsumer<AuthCubit, AuthState>(
                listenWhen: (previous, current) =>
                    current is AuthSuccess || current is AuthFailure,
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    _navigateToHome();
                  }
                  if (state is AuthFailure) {
                    setState(() {
                      _isLoading = false;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    });
                  }
                },

                bloc: BlocProvider.of<AuthCubit>(context),
                buildWhen: (previous, current) =>
                    current is AuthLoading ||
                    current is AuthSuccess ||
                    current is AuthFailure,
                builder: (context, state) {
                  if (state is AuthLoading) {
                    _isLoading = true;
                  }
                  return CustomButton(
                    text: 'Join Now',
                    onPressed: _handleSignUp,
                    isLoading: _isLoading,
                    height: 48.h,
                    fontSize: 16.sp,
                  );
                },
              ),

              SizedBox(height: 16.h),

              // Already have account link
              Center(
                child: GestureDetector(
                  onTap: _navigateToHome,
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Or sign up with
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey[400],
                      thickness: 1.h,
                      height: 1.h,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Or sign up with',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey[400],
                      thickness: 1.h,
                      height: 1.h,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Social buttons
              Row(
                children: [
                  IntrinsicWidth(
                    child: SocialLoginButton(
                      platform: 'Google',
                      imagePath: Assets.assetsIconsGoogle,
                      onPressed: _handleGoogleSignIn,
                      height: 48.h,
                      iconSize: 20.w,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  IntrinsicWidth(
                    child: SocialLoginButton(
                      platform: 'Microsoft',
                      imagePath: Assets.assetsIconsFacebook,
                      onPressed: _handleMicrosoftSignIn,
                      backgroundColor: Colors.white,
                      height: 48.h,
                      iconSize: 20.w,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              // Terms of Service
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'By Using this app you agree with the',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        // Open terms of service
                      },
                      child: Text(
                        'Terms of Service',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
