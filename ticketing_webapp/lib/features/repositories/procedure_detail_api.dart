import 'package:dio/dio.dart';
import 'package:ticketing_webapp/core/network/api_client.dart';
import 'package:ticketing_webapp/core/storage/session_manager.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/timeline_dto/timeline_dto.dart';

class ProcedureDetailApi {
  final ApiClient _apiClient;
  final SessionManager _sessionManager;

  ProcedureDetailApi({
    required ApiClient apiClient,
    required SessionManager sessionManager,
  }) : _apiClient = apiClient,
       _sessionManager = sessionManager;

  /// Chiama il nuovo endpoint GET /api/workflow/{id}/timeline[cite: 12]
  Future<TimelineDto> getFullTimeline(String procedureId) async {
    try {
      final token = await _sessionManager.getToken();

      final response = await _apiClient.dio.get(
        '/api/workflow/$procedureId/timeline', // Nuovo endpoint[cite: 12]
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return TimelineDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Errore di rete nel recupero della timeline: ${e.message}',
      );
    } catch (e) {
      throw Exception('Errore imprevisto nel parsing della timeline: $e');
    }
  }
}

/* class ProcedureDetailException implements Exception {
  final String message;
  const ProcedureDetailException(this.message);

  @override
  String toString() => message;
}

class ProcedureDetailApi {
  final ApiClient _apiClient;
  final SessionManager _sessionManager;

  ProcedureDetailApi({
    required ApiClient apiClient,
    required SessionManager sessionManager,
  }) : _apiClient = apiClient,
       _sessionManager = sessionManager;

  Future<ProcedureDetail> getProcedureById(String procedureId) async {
    try {
      final token = await _sessionManager.getToken();

      final response = await _apiClient.dio.get(
        '/api/procedures/$procedureId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return ProcedureDetail.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Errore di rete nel recupero del dettaglio: ${e.message}',
      );
    } catch (e) {
      throw Exception('Errore imprevisto nel parsing del dettaglio: $e');
    }
  }
} */
