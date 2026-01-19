import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/core/router/app_routes.dart';
import 'package:social_media_app/core/utils/assets.dart';
import 'package:social_media_app/features/auth/auth_cubit/auth_cubit.dart';
import 'package:social_media_app/features/auth/views/widgets/custom_button.dart';
import 'package:social_media_app/features/auth/views/widgets/custom_text_field.dart';
import 'package:social_media_app/features/auth/views/widgets/social_login_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;

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

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      BlocProvider.of<AuthCubit>(context).loginWithEmailAndPassword(
        _emailPhoneController.text,
        _passwordController.text,
      );
    }
  }

  void _handleGoogleSignIn() {
    // Implement Google sign in
  }

  void _handleMicrosoftSignIn() {
    // Implement Microsoft sign in
  }

  void _navigateToSignUp() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                // Fields
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
                    return null;
                  },
                ),

                SizedBox(height: 8.h),

                // Remember me & Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() => _rememberMe = value ?? false);
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Remember me',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Open forgot password page
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50.w, 30.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Sign In Button
                BlocConsumer<AuthCubit, AuthState>(
                  listenWhen: (previous, current) =>
                      current is AuthFailure || current is AuthSuccess,
                  listener: (context, state) {
                    if (state is AuthFailure) {
                      _isLoading = false;
                      setState(() {});
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                    if (state is AuthSuccess) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                    }
                  },
                  bloc: cubit,
                  buildWhen: (previous, current) =>
                      current is AuthLoading ||
                      current is AuthFailure ||
                      current is AuthSuccess,
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      _isLoading = true;
                    }
                    return CustomButton(
                      text: 'Sign In',
                      onPressed: _handleSignIn,
                      isLoading: _isLoading,
                      height: 48.h,
                      fontSize: 16.sp,
                    );
                  },
                ),

                SizedBox(height: 16.h),

                // Don't have account link
                Center(
                  child: GestureDetector(
                    onTap: _navigateToSignUp,
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14.sp,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
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

                // Or sign in with divider
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
                        'Or sign in with',
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
      ),
    );
  }

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
