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
      print('🔐 Starting login...');

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed');
      }

      print('✅ Login successful');
      print('👤 Auth User ID: ${response.user!.id}');
      print('📧 Auth User Email: ${response.user!.email}');
      print('📝 Auth User Metadata: ${response.user!.userMetadata}');

      // تحقق من وجود User في database
      try {
        final dbUser = await _db.fetchRow<UserDataModel>(
          table: 'users',
          primaryKey: 'id',
          id: response.user!.id,
          builder: (data, id) {
            print('📊 Database User Data: $data');
            return UserDataModel.fromMap(data);
          },
        );

        print('✅ Found user in database:');
        print('   - DB User ID: ${dbUser.id}');
        print('   - DB User Name: ${dbUser.name}');
        print('   - DB User Email: ${dbUser.email}');

        if (dbUser.id != response.user!.id) {
          print('❌ MISMATCH! Auth ID != DB ID');
          print('   Auth ID: ${response.user!.id}');
          print('   DB ID: ${dbUser.id}');
        }
      } catch (e) {
        print('⚠️ User NOT found in database');
        print('❌ Error: $e');

        // أضف User للـ database
        final name =
            response.user!.userMetadata?['name'] as String? ??
            response.user!.email?.split('@').first ??
            'User';

        print('📝 Creating user in database with ID: ${response.user!.id}');
        await setUserData(name, response.user!.email ?? '', response.user!.id);
      }
    } catch (e) {
      print('❌ Login failed: $e');
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      print('📝 Starting registration...');

      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user == null) {
        throw Exception('Registration failed');
      }

      print('✅ Registration successful');
      print('👤 New User ID: ${response.user!.id}');
      print('📧 New User Email: ${response.user!.email}');
      print('📝 New User Metadata: ${response.user!.userMetadata}');

      print('💾 Saving user to database...');
      await setUserData(name, email, response.user!.id);
      print('✅ User saved to database');
    } catch (e) {
      print('❌ Registration failed: $e');
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> setUserData(String name, String email, String userId) async {
    try {
      print('💾 setUserData called with:');
      print('   - User ID: $userId');
      print('   - Name: $name');
      print('   - Email: $email');

      // أول حاجة: شوف لو في user بنفس الـ email
      try {
        final existingUsers = await _db.fetchRows<UserDataModel>(
          table: 'users',
          builder: (data, id) => UserDataModel.fromMap(data),
          primaryKey: 'id',
          filter: (query) => query.eq('email', email),
        );

        if (existingUsers.isNotEmpty) {
          print('⚠️ Found existing user(s) with same email:');
          for (var user in existingUsers) {
            print('   - ID: ${user.id}');
            print('   - Name: ${user.name}');
          }

          // لو الـ ID مختلف، امسح القديم
          for (var user in existingUsers) {
            if (user.id != userId) {
              print('🗑️ Deleting old user with ID: ${user.id}');
              await _db.deleteRow(table: 'users', column: 'id', value: user.id);
              print('✅ Old user deleted');
            }
          }
        }
      } catch (e) {
        print('⚠️ No existing users found with email: $email');
      }

      final userData = UserDataModel(
        id: userId,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      print('📊 User data map: ${userData.toMap()}');

      // دلوقتي ضيف الـ user الجديد
      await _db.upsertRow(
        table: 'users',
        values: userData.toMap(),
        onConflict: 'id',
        ignoreDuplicates: false,
      );

      print('✅ User data saved successfully');

      // تحقق من الحفظ
      final savedUser = await _db.fetchRow<UserDataModel>(
        table: 'users',
        primaryKey: 'id',
        id: userId,
        builder: (data, id) => UserDataModel.fromMap(data),
      );

      print('✅ Verification - User saved with ID: ${savedUser.id}');
    } catch (e) {
      print('❌ Set user data error: $e');
      throw Exception('Set user data failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
      print('✅ Logout successful');
    } catch (e) {
      print('❌ Logout failed: $e');
      throw Exception('Logout failed: $e');
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
    if (user != null) {
      print('👤 Current User:');
      print('   - ID: ${user.id}');
      print('   - Email: ${user.email}');
    } else {
      print('❌ No current user');
    }
    return user;
  }
}
