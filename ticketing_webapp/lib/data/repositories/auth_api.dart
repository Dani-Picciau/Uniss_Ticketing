import 'package:dio/dio.dart';
import 'package:ticketing_webapp/constants/api_constants.dart';
import 'package:ticketing_webapp/data/models/login_response.dart';
import 'package:ticketing_webapp/data/storage/session_manager.dart';
import '../network/api_client.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthApi {
  final ApiClient _apiClient;
  final SessionManager _sessionManager;

  // Aggiorniamo il costruttore per richiedere il SessionManager
  const AuthApi({
    required ApiClient apiClient,
    required SessionManager sessionManager,
  }) : _apiClient = apiClient,
       _sessionManager = sessionManager;

  Future<LoginResponse> login(String email, String password) async {
    try {
      // Usiamo la costante direttamente nella POST
      final response = await _apiClient.dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final responseData = response.data as Map<String, dynamic>;
      final String? token = responseData['token'];

      if (token != null && token.isNotEmpty) {
        // Usiamo il metodo pulito del nostro SessionManager
        await _sessionManager.saveToken(token);
      }
      

      return LoginResponse.fromJson(responseData);
    } on DioException catch (e) {
      if (e.response != null) {
        final body = e.response?.data;
        final errorMessage =
            (body is Map<String, dynamic> && body.containsKey('error'))
            ? body['error'] as String
            : 'Errore di autenticazione';

        throw AuthException(errorMessage);
      } else {
        throw const AuthException(
          'Impossibile connettersi al server. Verifica la connessione.',
        );
      }
    } catch (e) {
      throw AuthException('Errore imprevisto durante il login: $e');
    }
  }

  Future<void> logout() async {
    // Deleghiamo anche la cancellazione al SessionManager
    await _sessionManager.deleteToken();
  }
}
