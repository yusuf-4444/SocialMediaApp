import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/services/upload_files_services.dart';
import 'package:social_media_app/features/auth/models/user_data_model.dart';
import 'package:social_media_app/features/auth/services/auth_services.dart';
import 'package:social_media_app/features/home/models/post_body_request.dart';
import 'package:social_media_app/features/home/models/posts_model.dart';
import 'package:social_media_app/features/home/models/story_model.dart';
import 'package:social_media_app/features/home/services/home_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final HomeServicesImpl _db = HomeServicesImpl();
  final AuthServicesImpl authServices = AuthServicesImpl();
  final UploadFilesServicesImpl _uploadServices = UploadFilesServicesImpl();
  File? pickedImage;
  File? pickedVideo;

  Future<void> fetchStories() async {
    emit(StoriesLoading());
    try {
      final stories = await _db.fetchStories();
      final List<StoryModel> finalStories = [];

      for (final story in stories) {
        final user = await _db.getUsersData(story.authorId);
        finalStories.add(
          story.copyWith(name: user.name, imageUrl: user.imageUrl),
        );
      }

      emit(StoriesLoaded(finalStories));
    } catch (e) {
      print(e);
      emit(StoriesError(e.toString()));
    }
  }

  Future<void> fetchPosts() async {
    emit(PostsLoading());
    try {
      final posts = await _db.fetchPosts();
      final List<PostsModel> finalPosts = [];

      for (final post in posts) {
        final user = await _db.getUsersData(post.authorId);
        finalPosts.add(
          post.copyWith(name: user.name, userImage: user.imageUrl),
        );
      }
      emit(PostsLoaded(finalPosts));
    } catch (e) {
      print(e);
      emit(PostsError(e.toString()));
    }
  }

  Future<void> createPost(String text, String imageUrl) async {
    try {
      emit(PostCreating());

      final user = Supabase.instance.client.auth.currentUser;

      print('🔍 Checking user in createPost...');
      print('👤 User ID: ${user?.id}');
      print('📧 User Email: ${user?.email}');

      if (user == null) {
        print('❌ No user found!');
        emit(PostCreatedError('You must be logged in to create a post'));
        return;
      }

      print('✅ User found, creating post...');

      final post = PostBodyRequest(
        userId: user.id,
        text: text,
        imageUrl: imageUrl,
      );

      await _db.createPost(post);
      print('✅ Post created successfully!');

      emit(PostCreated());

      await fetchPosts();
    } catch (e) {
      print('❌ Error creating post: $e');
      emit(PostCreatedError(e.toString()));
    }
  }

  Future<void> fetchUserData() async {
    try {
      final user = await _db.getUserData();

      if (user != null) {
        emit(UserFetched(user));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> pickImageFromGallery() async {
    final image = await _uploadServices.uploadImageFromGallery();
    if (image == null) {
      emit(ImagePickingError('No image picked'));
    } else {
      pickedImage = File(image.path);
      emit(ImagePicked(pickedImage!.path));
    }
  }

  Future<void> pickVideoFromGallery() async {
    final video = await _uploadServices.uploadVideoFromGallery();
    if (video == null) {
      emit(VideoPickingError('No video picked'));
    } else {
      pickedVideo = File(video.path);
      emit(VideoPicked(pickedVideo!.path));
    }
  }

  Future<void> pickImageFromCamera() async {
    final image = await _uploadServices.uploadImageFromCamera();
    if (image == null) {
      emit(ImagePickingError('No image picked'));
    } else {
      pickedImage = File(image.path);
      emit(ImagePicked(pickedImage!.path));
    }
  }
}
