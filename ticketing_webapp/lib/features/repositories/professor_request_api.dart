import 'package:dio/dio.dart';
import 'package:ticketing_webapp/constants/api_constants.dart';
import 'package:ticketing_webapp/core/network/api_client.dart';
import 'package:ticketing_webapp/core/storage/session_manager.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/new_request/models/requests/professor_request.dart';
import 'package:ticketing_webapp/ui/scenes/models/requests/professor_request_summary.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/incoming_requests/models/assign_request_dto.dart';

// ===========================================================================
// ECCEZIONE UNICA PER LE RICHIESTE
// ===========================================================================
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
    required ApiClient apiClient,
    required SessionManager sessionManager,
  }) : _apiClient = apiClient,
       _sessionManager = sessionManager;

  // ===========================================================================
  // SEZIONE 1: CREAZIONE RICHIESTE
  // ===========================================================================

  Future<void> createProfessorRequest(ProfessorRequest request) async {
    try {
      final token = await _sessionManager.getToken();
      await _apiClient.dio.post(
        ApiConstants.professorRequests,
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      _handleError(e, 'Errore nel server durante la creazione');
    } catch (e) {
      throw ProfessorRequestException('Errore imprevisto: $e');
    }
  }

  Future<void> linkProcedureToRequest(
    String requestId,
    String procedureId,
  ) async {
    try {
      final token = await _sessionManager.getToken();
      await _apiClient.dio.put(
        '${ApiConstants.professorRequests}/$requestId/link-procedure',
        data: {'procedureId': procedureId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      _handleError(
        e,
        'Errore durante il collegamento della richiesta alla procedura',
      );
    } catch (e) {
      throw ProfessorRequestException('Errore imprevisto: $e');
    }
  }

  // ===========================================================================
  // SEZIONE 2: ASSEGNAZIONE RICHIESTE
  // ===========================================================================

  Future assignRequestToAdmin(String requestId, String administratorId) async {
    try {
      final token = await _sessionManager.getToken();

      final dto = AssignRequestDto(administratorId: administratorId);

      await _apiClient.dio.put(
        '${ApiConstants.professorRequests}/$requestId/assign',
        data: dto.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      _handleError(e, 'Errore durante la riassegnazione della richiesta');
    } catch (e) {
      throw ProfessorRequestException('Errore imprevisto: $e');
    }
  }

  // ===========================================================================
  // SEZIONE 3: LETTURA E RICERCA RICHIESTE
  // ===========================================================================

  Future<List<ProfessorRequestSummary>> getFilteredRequests({
    String? status,
    String? viewAs,
  }) async {
    try {
      final token = await _sessionManager.getToken();

      final queryParams = <String, dynamic>{};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (viewAs != null && viewAs.isNotEmpty) {
        queryParams['viewAs'] = viewAs;
      }

      final response = await _apiClient.dio.get(
        '${ApiConstants.professorRequests}/filtered',
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final responseData = response.data as List;

      return responseData
          .map(
            (json) =>
                ProfessorRequestSummary.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      _handleError(e, 'Errore nel recupero delle tue richieste dal server');
    } catch (e) {
      throw ProfessorRequestException(
        'Errore imprevisto durante il recupero delle tue richieste: $e',
      );
    }
  }

  // ===========================================================================
  // SEZIONE 4: ELIMINAZIONE RICHIESTE
  // ===========================================================================

  Future<void> deleteRequest(String id) async {
    try {
      final token = await _sessionManager.getToken();

      // Eseguiamo una DELETE passando l'ID nell'URL
      await _apiClient.dio.delete(
        '${ApiConstants.professorRequests}/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      _handleError(e, 'Errore durante l\'eliminazione della richiesta');
    } catch (e) {
      throw ProfessorRequestException(
        'Errore imprevisto durante l\'eliminazione: $e',
      );
    }
  }

  // ===========================================================================
  // SEZIONE 5: HELPER METODO PRIVATO PER GESTIONE ERRORI DIO
  // ===========================================================================

  Never _handleError(DioException e, String fallbackMessage) {
    if (e.response != null) {
      final body = e.response?.data;
      final errorMessage =
          (body is Map<String, dynamic> && body.containsKey('error'))
          ? body['error'] as String
          : '$fallbackMessage (status ${e.response?.statusCode})';
      throw ProfessorRequestException(errorMessage);
    } else {
      throw const ProfessorRequestException(
        'Impossibile connettersi al server. Verifica la connessione.',
      );
    }
  }
}
