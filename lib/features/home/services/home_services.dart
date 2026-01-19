import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/features/auth/models/user_data_model.dart';
import 'package:social_media_app/features/home/models/post_body_request.dart';
import 'package:social_media_app/features/home/models/posts_model.dart';
import 'package:social_media_app/features/home/models/story_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class HomeServices {
  Future<List<StoryModel>> fetchStories();
  Future<UserDataModel?> getUserData();
  Future<UserDataModel> getUsersData(String userId);
  Future<List<PostsModel>> fetchPosts();
  Future<void> createPost(PostBodyRequest post);
}

class HomeServicesImpl implements HomeServices {
  final SupabaseDatabaseServices _db = SupabaseDatabaseServices.instance;
  final SupabaseClient supabase = Supabase.instance.client;
  @override
  Future<List<StoryModel>> fetchStories() async {
    try {
      return await _db.fetchRows(
        table: 'stories',
        builder: (data, id) => StoryModel.fromMap(data),
        primaryKey: 'id',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserDataModel?> getUserData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;
      final response = await _db.fetchRow(
        table: 'users',
        primaryKey: 'id',
        id: user.id,
        builder: (data, id) => UserDataModel.fromMap(data),
      );
      return UserDataModel.fromMap(response.toMap());
    } catch (e) {
      throw Exception('Get user data failed: $e');
    }
  }

  @override
  Future<UserDataModel> getUsersData(String userId) async {
    try {
      return await _db.fetchRow(
        table: 'users',
        primaryKey: 'id',
        id: userId,
        builder: (data, id) => UserDataModel.fromMap(data),
      );
    } catch (e) {
      throw Exception('Get user data failed: $e');
    }
  }

  @override
  Future<List<PostsModel>> fetchPosts() async {
    try {
      return await _db.fetchRows(
        table: 'posts',
        builder: (data, id) => PostsModel.fromMap(data),
        primaryKey: 'id',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createPost(PostBodyRequest post) async {
    try {
      return await _db.insertRow(table: 'posts', values: post.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
