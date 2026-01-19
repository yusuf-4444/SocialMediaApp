import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/services/auth_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final AuthServicesImpl authServices = AuthServicesImpl();

  // ✅ Method جديدة للتحقق من الـ auth status
  void checkAuthStatus() {
    try {
      final user = authServices.fetchCurrentUser();
      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthLoading());
      await authServices.loginWithEmailAndPassword(email, password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      emit(AuthLoading());
      await authServices.registerWithEmailAndPassword(email, password, name);
      emit(AuthSuccess());
    } catch (e) {
      print(e);
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(AuthLoading());
      await authServices.logout();
      emit(AuthLogout());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  void getUserData() {
    try {
      final user = authServices.fetchCurrentUser();
      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(message: 'No user found'));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
