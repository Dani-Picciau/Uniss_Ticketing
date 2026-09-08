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

  // FLUSSO DATI DELLA LISTA PROCEDURE:
  /// 1. Il backend (ProcedureController.java) restituisce l'entità completa (Procedure.java).
  /// 2. Spring Boot trasforma tutto in un JSON molto grande e lo invia qui.
  /// 3. Flutter riceve il JSON completo, ma usando ProcedureSummary.fromJson()
  ///    estrae e conserva IN MEMORIA SOLO i campi dichiarati nel modello Freezed,
  ///    ignorando automaticamente tutti gli altri dati (come le liste degli step).
  /// Se in futuro serve un nuovo dato nella UI della lista, basta aggiungerlo
  /// al file procedure_summary.dart (assicurandosi che il nome del campo
  /// combaci esattamente con quello di Procedure.java).
  Future<List<ProcedureSummary>> getProceduresByType(
    String procedureType,
  ) async {
    try {
      final token = await _sessionManager.getToken();

      final response = await _apiClient.dio.get(
        ApiConstants.procedures,
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

  Future<void> deleteProcedure(String id) async {
    try {
      final token = await _sessionManager.getToken();

      // Eseguiamo una DELETE passando l'ID nell'URL
      await _apiClient.dio.delete(
        '${ApiConstants.procedures}/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final body = e.response?.data;
        final errorMessage =
            (body is Map<String, dynamic> && body.containsKey('error'))
            ? body['error'] as String
            : 'Errore durante l\'eliminazione della procedura';

        throw ProcedureListException(errorMessage);
      } else {
        throw const ProcedureListException(
          'Impossibile connettersi al server. Verifica la connessione.',
        );
      }
    } catch (e) {
      throw ProcedureListException(
        'Errore imprevisto durante l\'eliminazione: $e',
      );
    }
  }
}
