import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/data/repositories/auth_api.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthApi _authApi;

  // Richiediamo AuthApi nel costruttore
  LoginCubit({required AuthApi authApi})
    : _authApi = authApi,
      super(const LoginState());

  Future<void> login(String email, String password) async {
    // Controllo campi vuoti
    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(status: LoginStatus.warning));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      // Chiamata VERA al backend Spring Boot
      final result = await _authApi.login(email, password);

      // Se arriviamo qui, il login è andato a buon fine
      emit(
        state.copyWith(
          status: LoginStatus.success,
          authResult: result, // Passiamo i dati dell'utente alla UI
        ),
      );
    } on AuthException catch (e) {
      // Stampa l'errore in console per fare debug
      print('Errore di autenticazione: ${e.message}');
      emit(state.copyWith(status: LoginStatus.error));
    } catch (e) {
      print('Errore imprevisto: $e');
      emit(state.copyWith(status: LoginStatus.error));
    }
  }
}
