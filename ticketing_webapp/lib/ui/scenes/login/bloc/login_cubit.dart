import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/bloc/auth_cubit.dart';
import 'package:ticketing_webapp/features/repositories/auth_api.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthApi _authApi;
  final AuthCubit _authCubit;

  LoginCubit({required AuthApi authApi, required AuthCubit authCubit})
    : _authApi = authApi,
      _authCubit = authCubit,
      super(const LoginState());

  Future<void> login(String email, String password) async {
    // Controllo campi vuoti
    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(status: LoginStatus.warning));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final result = await _authApi.login(email, password);

      _authCubit.setAuthenticatedUser(result);

      emit(state.copyWith(status: LoginStatus.success));
    } on AuthException catch (e) {
      // Stampa l'errore in console per fare debug
      ('Errore di autenticazione: ${e.message}');
      emit(state.copyWith(status: LoginStatus.error));
    } catch (e) {
      ('Errore imprevisto: $e');
      emit(state.copyWith(status: LoginStatus.error));
    }
  }
}
