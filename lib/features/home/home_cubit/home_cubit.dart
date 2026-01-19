import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/services/auth_services.dart';
import 'package:social_media_app/features/home/models/post_body_request.dart';
import 'package:social_media_app/features/home/models/posts_model.dart';
import 'package:social_media_app/features/home/models/story_model.dart';
import 'package:social_media_app/features/home/services/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final HomeServicesImpl _db = HomeServicesImpl();
  final AuthServicesImpl authServices = AuthServicesImpl();

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
      final user = authServices.fetchCurrentUser();
      if (user == null) {
        throw Exception('User not found');
      }
      final post = PostBodyRequest(
        userId: user.id,
        text: text,
        imageUrl: imageUrl,
      );
      await _db.createPost(post);
      emit(PostCreated());
    } catch (e) {
      print(e);
      emit(PostCreatedError(e.toString()));
    }
  }
}
