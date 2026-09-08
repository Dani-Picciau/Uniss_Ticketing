import 'package:dio/dio.dart';
import 'package:ticketing_webapp/constants/api_constants.dart';
import 'package:ticketing_webapp/core/network/api_client.dart';
import 'package:ticketing_webapp/core/storage/session_manager.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/new_request/models/requests/professor_request.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/requests/models/requests/incoming_request_summary.dart';

class ProfessorRequestException implements Exception {
  final String message;
  const ProfessorRequestException(this.message);

  @override
  String toString() => message;
}

class ProfessorRequestApi {
  final ApiClient _apiClient;
  final SessionManager _sessionManager;

  ProfessorRequestApi({
    required this._apiClient,
    required this._sessionManager,
  });

  Future<void> createProfessorRequest(ProfessorRequest request) async {
    try {
      final token = await _sessionManager.getToken();
      await _apiClient.dio.post(
        ApiConstants.professorRequests,
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      final body = e.response?.data;
      final errorMessage =
          (body is Map<String, dynamic> && body.containsKey('error'))
          ? body['error'] as String
          : 'Errore nel server durante la creazione (status ${e.response?.statusCode})';
      throw ProfessorRequestException(errorMessage);
    } catch (e) {
      throw ProfessorRequestException('Errore imprevisto: $e');
    }
  }

  /// Recupera la lista delle richieste in base allo stato (es. "IN_ATTESA")
  Future<List<IncomingRequestSummary>> getRequestsByStatus(
    String status,
  ) async {
    try {
      final token = await _sessionManager.getToken();

      final response = await _apiClient.dio.get(
        '${ApiConstants.professorRequests}/status/$status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final responseData = response.data as List<dynamic>;

      return responseData
          .map(
            (json) =>
                IncomingRequestSummary.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final body = e.response?.data;
        final errorMessage =
            (body is Map<String, dynamic> && body.containsKey('error'))
            ? body['error'] as String
            : 'Errore nel recupero delle richieste dal server';

        throw ProfessorRequestException(errorMessage);
      } else {
        throw const ProfessorRequestException(
          'Impossibile connettersi al server. Verifica la connessione.',
        );
      }
    } catch (e) {
      throw ProfessorRequestException(
        'Errore imprevisto durante il recupero delle richieste: $e',
      );
    }
  }

  Future<void> deleteRequest(String id) async {
    try {
      final token = await _sessionManager.getToken();

      // Eseguiamo una DELETE passando l'ID nell'URL
      await _apiClient.dio.delete(
        '${ApiConstants.professorRequests}/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final body = e.response?.data;
        final errorMessage =
            (body is Map<String, dynamic> && body.containsKey('error'))
            ? body['error'] as String
            : 'Errore durante l\'eliminazione della richiesta';

        throw ProfessorRequestException(errorMessage);
      } else {
        throw const ProfessorRequestException(
          'Impossibile connettersi al server. Verifica la connessione.',
        );
      }
    } catch (e) {
      throw ProfessorRequestException(
        'Errore imprevisto durante l\'eliminazione: $e',
      );
    }
  }
}
