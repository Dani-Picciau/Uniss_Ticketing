import 'package:dio/dio.dart';
import 'package:ticketing_webapp/constants/api_constants.dart';
import 'package:ticketing_webapp/core/network/api_client.dart';
import 'package:ticketing_webapp/core/storage/session_manager.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/new_request/models/requests/professor_request.dart';

class NewProfessorRequestException implements Exception {
  final String message;
  const NewProfessorRequestException(this.message);

  @override
  String toString() => message;
}

class NewProfessorRequestApi {
  final ApiClient _apiClient;
  final SessionManager _sessionManager;

  NewProfessorRequestApi({
    required this._apiClient,
    required this._sessionManager,
  });

  Future<void> createProfessorRequest(ProfessorRequest request) async {
    try {
      final token = await _sessionManager.getToken();
      await _apiClient.dio.post(
        ApiConstants.newProfessorRequest,
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      final body = e.response?.data;
      final errorMessage =
          (body is Map<String, dynamic> && body.containsKey('error'))
          ? body['error'] as String
          : 'Errore nel server durante la creazione (status ${e.response?.statusCode})';
      throw NewProfessorRequestException(errorMessage);
    } catch (e) {
      throw NewProfessorRequestException('Errore imprevisto: $e');
    }
  }
}
