import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/core/storage/session_manager.dart';
import 'package:ticketing_webapp/features/bloc/auth_state.dart';
import 'package:ticketing_webapp/features/repositories/auth_api.dart';
import 'package:ticketing_webapp/features/models/login_response.dart'; // Assicurati di importarlo

class AuthCubit extends Cubit<AuthState> {
  final AuthApi _authApi;

  AuthCubit({required AuthApi authApi, required SessionManager sessionManager})
    : _authApi = authApi,
      super(const AuthState());

  void setAuthenticatedUser(LoginResponse user) {
    emit(state.copyWith(status: AuthStatus.authenticated, user: user));
  }

  Future<void> logout() async {
    await _authApi.logout();
    emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
  }
}
