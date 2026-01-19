import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:social_media_app/core/views/pages/widgets/custom_gradient_background.dart';
import 'package:social_media_app/features/home/home_cubit/home_cubit.dart';
import 'package:social_media_app/features/home/views/pages/post_card.dart';
import 'package:social_media_app/features/home/views/widgets/custom_post_card.dart';
import 'package:social_media_app/features/home/views/widgets/home_header.dart';
import 'package:social_media_app/features/home/views/widgets/stories_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: BlocProvider(
          create: (context) => HomeCubit()
            ..fetchStories()
            ..fetchPosts(),
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    children: [
                      HomeHeader(),
                      Gap(24),
                      CustomPostCard(),
                      Gap(12),
                      StoriesSection(),
                      Gap(24),
                    ],
                  ),
                ),
              ),

              // Posts List
              PostsSections(),
            ],
          ),
        ),
      ),
    );
  }
}

class PostsSections extends StatelessWidget {
  const PostsSections({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is PostsLoaded ||
          current is PostsLoading ||
          current is PostsError,
      builder: (context, state) {
        if (state is PostsLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is PostsError) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        } else if (state is PostsLoaded) {
          if (state.posts.isEmpty) {
            return const SliverFillRemaining(
              child: Center(child: Text('No posts yet')),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return PostCard(post: state.posts[index]);
              }, childCount: state.posts.length),
            ),
          );
        }

        return const SliverFillRemaining(
          child: Center(child: Text('No posts available')),
        );
      },
    );
  }
}
