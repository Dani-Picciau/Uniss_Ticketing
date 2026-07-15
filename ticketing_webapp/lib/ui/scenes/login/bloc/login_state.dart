import 'package:ticketing_webapp/data/models/login_response.dart';

enum LoginStatus { initial, loading, success, error, warning }

class LoginState {
  final LoginStatus status;
  final LoginResponse? loginResponse;

  const LoginState({this.status = LoginStatus.initial, this.loginResponse});

  // Aggiungi authResult qui dentro tra i parametri!
  LoginState copyWith({LoginStatus? status, LoginResponse? loginResponse}) {
    return LoginState(
      status: status ?? this.status,
      loginResponse: loginResponse ?? this.loginResponse,
    );
  }
}
