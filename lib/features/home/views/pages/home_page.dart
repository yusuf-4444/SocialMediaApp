import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:social_media_app/core/views/pages/widgets/custom_gradient_background.dart';
import 'package:social_media_app/features/home/home_cubit/home_cubit.dart';
import 'package:social_media_app/features/home/views/widgets/custom_post_card.dart';
import 'package:social_media_app/features/home/views/widgets/home_header.dart';
import 'package:social_media_app/features/home/views/widgets/stories_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: BlocProvider(
            create: (context) => HomeCubit()..fetchStories(),
            child: Column(
              children: [
                HomeHeader(),
                Gap(24),
                CustomPostCard(),
                Gap(12),
                StoriesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
