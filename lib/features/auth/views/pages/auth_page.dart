import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:social_media_app/core/utils/app_colors.dart';
import 'package:social_media_app/core/utils/assets.dart';
import 'package:social_media_app/core/views/pages/widgets/custom_gradient_background.dart';
import 'package:social_media_app/features/auth/views/pages/sign_in_page.dart';
import 'package:social_media_app/features/auth/views/pages/sign_up_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Padding(padding: const EdgeInsets.all(8.0), child: const Text("Sign in")),
      Padding(padding: const EdgeInsets.all(8.0), child: const Text("Sign up")),
    ];
    final List<Widget> screens = [const SignInPage(), const SignUpPage()];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: CustomAuth(tabs: tabs, screens: screens),
          ),
        ),
      ),
    );
  }
}

class CustomAuth extends StatelessWidget {
  const CustomAuth({super.key, required this.tabs, required this.screens});

  final List<Padding> tabs;
  final List<Widget> screens;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              Image.asset(Assets.assetsImagesLogo),
              Gap(50.h),
              TabBar(
                controller: DefaultTabController.of(context),
                tabs: tabs,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppColors.black,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2,
                labelStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(20),
              Expanded(
                child: TabBarView(
                  controller: DefaultTabController.of(context),
                  children: screens,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
