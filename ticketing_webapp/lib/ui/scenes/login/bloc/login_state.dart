import 'package:ticketing_webapp/data/network/auth_result.dart';

enum LoginStatus { initial, loading, success, error, warning }

class LoginState {
  final LoginStatus status;
  final AuthResult? authResult;

  const LoginState({this.status = LoginStatus.initial, this.authResult});

  // Aggiungi authResult qui dentro tra i parametri!
  LoginState copyWith({LoginStatus? status, AuthResult? authResult}) {
    return LoginState(
      status: status ?? this.status,
      authResult: authResult ?? this.authResult,
    );
  }
}
