import 'package:social_media_app/core/services/supabase_database_services.dart';
import 'package:social_media_app/features/auth/models/user_data_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthServices {
  Future<void> loginWithEmailAndPassword(String email, String password);
  Future<void> logout();
  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  );
  Future<void> resetPassword(String email);
  Future<void> setUserData(String name, String email, String userId);
}

class AuthServicesImpl implements AuthServices {
  final SupabaseClient supabase = Supabase.instance.client;
  final SupabaseDatabaseServices _db = SupabaseDatabaseServices.instance;
  @override
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw Exception('Login failed');
      } else {
        return;
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  @override
  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user == null) {
        throw Exception('Registration failed');
      } else {
        await setUserData(name, email, response.user!.id);
        return;
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> setUserData(String name, String email, String userId) async {
    try {
      final userData = UserDataModel(
        id: userId,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      await _db.insertRow(table: 'users', values: userData.toMap());
    } catch (e) {
      print(e);
      throw Exception('Set user data failed: $e');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Reset password failed: $e');
    }
  }

  User? fetchCurrentUser() {
    final user = supabase.auth.currentUser;
    if (user == null) return null;
    return user;
  }
}
