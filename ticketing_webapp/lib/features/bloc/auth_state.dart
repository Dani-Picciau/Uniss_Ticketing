import 'package:ticketing_webapp/features/models/login_response.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final LoginResponse? user;

  const AuthState({this.status = AuthStatus.unknown, this.user});

  AuthState copyWith({AuthStatus? status, LoginResponse? user}) {
    return AuthState(status: status ?? this.status, user: user ?? this.user);
  }
}
