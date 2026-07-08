import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ticketing_webapp/constants/api_constants.dart';
import 'package:ticketing_webapp/data/network/auth_result.dart';
import '../network/api_client.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthApi {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  const AuthApi({
    required ApiClient apiClient,
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _apiClient = apiClient,
       _storage = storage;

  Future<AuthResult> login(String email, String password) async {
    try {
      // Usiamo la costante direttamente nella POST
      final response = await _apiClient.dio.post(
        ApiConstants.login, 
        data: {'email': email, 'password': password},
      );

      final responseData = response.data as Map<String, dynamic>;
      final String? token = responseData['token'];

      if (token != null && token.isNotEmpty) {
        await _storage.write(key: 'jwt_token', value: token);
      }

      return AuthResult.fromJson(responseData);
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
    await _storage.delete(key: 'jwt_token');
  }
}
