import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/services/auth_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final AuthServicesImpl authServices = AuthServicesImpl();

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
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(AuthLoading());
      await authServices.logout();
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  void getUserData() {
    try {
      authServices.fetchCurrentUser();
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
