import 'package:dio/dio.dart';
import 'package:ticketing_webapp/constants/api_constants.dart';
import 'package:ticketing_webapp/core/network/api_client.dart';
import 'package:ticketing_webapp/core/storage/session_manager.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/procedure_summary/procedure_summary.dart';

class ProcedureListException implements Exception {
  final String message;
  const ProcedureListException(this.message);

  @override
  String toString() => message;
}

class ProcedureListApi {
  final ApiClient _apiClient;
  final SessionManager _sessionManager;

  ProcedureListApi({required this._apiClient, required this._sessionManager});

  Future<List<ProcedureSummary>> getproceduresByType(
    String procedureType,
  ) async {
    try {
      final token = await _sessionManager.getToken();

      final response = await _apiClient.dio.get(
        ApiConstants
            .procedures, 
        queryParameters: {'type': procedureType},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final responseData = response.data as List<dynamic>;
      return responseData
          .map(
            (json) => ProcedureSummary.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      if (e.response != null) {
        final body = e.response?.data;
        final errorMessage =
            (body is Map<String, dynamic> && body.containsKey('error'))
            ? body['error'] as String
            : 'Errore nel recupero delle procedure dal server';

        throw ProcedureListException(errorMessage);
      } else {
        throw const ProcedureListException(
          'Impossibile connettersi al server. Verifica la connessione.',
        );
      }
    } catch (e) {
      throw ProcedureListException(
        'Errore imprevisto durante il recupero delle procedure: $e',
      );
    }
  }
}
