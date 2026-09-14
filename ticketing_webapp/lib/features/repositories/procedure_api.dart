import 'package:dio/dio.dart';
import 'package:ticketing_webapp/constants/api_constants.dart';
import 'package:ticketing_webapp/core/network/api_client.dart';
import 'package:ticketing_webapp/core/storage/session_manager.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/models/requests/procedure_request.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/models/response/administrator_response/administrator_response.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/models/response/professor_response/professor_response.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/procedure_summary/procedure_summary.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/timeline_dto/timeline_dto.dart';

class ProcedureException implements Exception {
  final String message;
  const ProcedureException(this.message);

  @override
  String toString() => message;
}

class ProcedureApi {
  final ApiClient _apiClient;
  final SessionManager _sessionManager;

  ProcedureApi({
    required ApiClient apiClient,
    required SessionManager sessionManager,
  }) : _apiClient = apiClient,
       _sessionManager = sessionManager;

  // ===========================================================================
  // SEZIONE 1: CREAZIONE E RINNOVO PROCEDURE
  // ===========================================================================
  Future<String> createProcedure(ProcedureRequest request) async {
    try {
      final token = await _sessionManager.getToken();
      final response = await _apiClient.dio.post(
        ApiConstants.createProcedure,
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['id']
          as String; // Restituisco l'id della procedura appena creata
    } on DioException catch (e) {
      _handleError(e, 'Errore nel server durante la creazione della procedura');
    } catch (e) {
      throw ProcedureException('Errore imprevisto: $e');
    }
  }

  Future<void> renewScholarship(String procedureId, int duration) async {
    try {
      final token = await _sessionManager.getToken();

      // Assicurati che l'URL base corrisponda a quello del tuo backend
      await _apiClient.dio.post(
        ApiConstants.renewScholarship(procedureId),
        data: {'duration': duration},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      _handleError(e, 'Errore nel server durante il rinnovo della borsa');
    } catch (e) {
      throw ProcedureException('Errore imprevisto durante il rinnovo: $e');
    }
  }

  // ===========================================================================
  // SEZIONE 2: LETTURA E GESTIONE LISTA
  // ===========================================================================

  // FLUSSO DATI DELLA LISTA PROCEDURE:
  /// 1. Il backend (ProcedureController.java) restituisce l'entità completa (Procedure.java).
  /// 2. Spring Boot trasforma tutto in un JSON molto grande e lo invia qui.
  /// 3. Flutter riceve il JSON completo, ma usando ProcedureSummary.fromJson()
  ///    estrae e conserva IN MEMORIA SOLO i campi dichiarati nel modello Freezed,
  ///    ignorando automaticamente tutti gli altri dati (come le liste degli step).
  /// Se in futuro serve un nuovo dato nella UI della lista, basta aggiungerlo
  /// al file procedure_summary.dart (assicurandosi che il nome del campo
  /// combaci esattamente con quello di Procedure.java).
  // Cambiamo il nome per renderlo più generico, dato che ora accetta sia type che status
  Future<List<ProcedureSummary>> getProcedures({
    String? procedureType,
    String? status,
    String? viewAs,
  }) async {
    try {
      final token = await _sessionManager.getToken();

      // Prepariamo i query parameters solo se non sono nulli
      final queryParams = <String, dynamic>{};
      if (procedureType != null && procedureType.isNotEmpty) {
        queryParams['type'] = procedureType;
      }
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (viewAs != null && viewAs.isNotEmpty) {
        queryParams['viewAs'] = viewAs;
      }

      final response = await _apiClient.dio.get(
        ApiConstants.procedures,
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final responseData = response.data as List<dynamic>;

      return responseData.map((item) {
        final dtoMap = item as Map<String, dynamic>;
        final procedureMap = dtoMap['procedure'] as Map<String, dynamic>;

        procedureMap['ticketSubject'] = dtoMap['ticketSubject'];
        procedureMap['ticketContent'] = dtoMap['ticketContent'];

        return ProcedureSummary.fromJson(procedureMap);
      }).toList();
    } on DioException catch (e) {
      _handleError(e, 'Errore durante il recupero delle procedure');
    } catch (e) {
      throw ProcedureException('Errore imprevisto durante il recupero: $e');
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

        throw ProcedureException(errorMessage);
      } else {
        throw const ProcedureException(
          'Impossibile connettersi al server. Verifica la connessione.',
        );
      }
    } catch (e) {
      throw ProcedureException('Errore imprevisto durante l\'eliminazione: $e');
    }
  }

  // ===========================================================================
  // SEZIONE 3: GESTIONE TIMELINE E WORKFLOW
  // ===========================================================================

  /// Chiama il nuovo endpoint GET /api/workflow/{id}/timeline
  Future<TimelineDto> getFullTimeline(String procedureId) async {
    try {
      final token = await _sessionManager.getToken();

      final response = await _apiClient.dio.get(
        '/api/workflow/$procedureId/timeline',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return TimelineDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleError(e, 'Errore di rete nel recupero della timeline');
    } catch (e) {
      throw ProcedureException(
        'Errore imprevisto nel parsing della timeline: $e',
      );
    }
  }

  Future<void> updateRequirementStatus({
    required String procedureId,
    required String requirementName,
    required bool satisfied,
  }) async {
    try {
      final token = await _sessionManager.getToken();
      await _apiClient.dio.put(
        '/api/workflow/$procedureId/requirement',
        data: {'requirementName': requirementName, 'satisfied': satisfied},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      _handleError(e, 'Errore durante l\'aggiornamento del requisito');
    } catch (e) {
      throw ProcedureException('Errore imprevisto: $e');
    }
  }

  // Completa lo step e avanza (POST /api/workflow/{id}/advance)
  Future<void> advanceToNextStep({required String procedureId}) async {
    try {
      final token = await _sessionManager.getToken();
      await _apiClient.dio.post(
        '/api/workflow/$procedureId/advance',
        data: {'skip': false},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      _handleError(e, 'Errore durante l\'avanzamento dello step');
    } catch (e) {
      throw ProcedureException('Errore imprevisto: $e');
    }
  }

  Future<void> updateStepDetails({
    required String procedureId,
    String? notes,
    String? deadline,
  }) async {
    try {
      final token = await _sessionManager.getToken();
      await _apiClient.dio.put(
        '/api/workflow/$procedureId/step-details',
        data: {'notes': notes, 'deadline': deadline},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      _handleError(
        e,
        'Errore durante l\'aggiornamento dei dettagli dello step',
      );
    } catch (e) {
      throw ProcedureException('Errore imprevisto: $e');
    }
  }

  // ===========================================================================
  // SEZIONE 4: LETTURA UTENTI (Professor e Administrator)
  // ===========================================================================

  Future<List<ProfessorResponse>> getProfessor() async {
    try {
      final token = await _sessionManager.getToken();

      // Il token viene inserito negli header della richiesta GET
      final response = await _apiClient.dio.get(
        ApiConstants.professor,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final responseData = response.data as List<dynamic>;

      // Trasformiamo ogni oggetto JSON in un ProfessorResponse
      final professors = responseData
          .map(
            (json) => ProfessorResponse.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      return professors;
    } on DioException catch (e) {
      _handleError(e, 'Errore nel recupero dei docenti dal server');
    } catch (e) {
      throw ProcedureException(
        'Errore imprevisto durante il recupero dei docenti: $e',
      );
    }
  }

  Future<List<AdministratorResponse>> getAssignedAdministrator() async {
    try {
      final token = await _sessionManager.getToken();

      // Il token viene inserito negli header della richiesta GET
      final response = await _apiClient.dio.get(
        ApiConstants.assignedAdministrator,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final responseData = response.data as List<dynamic>;

      // Trasformiamo ogni oggetto JSON in un ProfessorResponse
      final assignedAdministrator = responseData
          .map(
            (json) =>
                AdministratorResponse.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      return assignedAdministrator;
    } on DioException catch (e) {
      _handleError(e, 'Errore nel recupero degli amministratori dal server');
    } catch (e) {
      throw ProcedureException(
        'Errore imprevisto durante il recupero amministratori: $e',
      );
    }
  }
  // ===========================================================================
  // RIASSEGNAZIONE DELLE PROCEDURE
  // ===========================================================================
  // ===========================================================================
  // RIASSEGNAZIONE DELLE PROCEDURE
  // ===========================================================================

  Future assignProcedureToAdmin(
    String procedureId,
    String newAdministratorId,
  ) async {
    try {
      final token = await _sessionManager.getToken();

      await _apiClient.dio.put(
        '/api/workflow/$procedureId/reassign',
        data: {'newAdministratorId': newAdministratorId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      _handleError(e, 'Errore durante la riassegnazione della procedura');
    } catch (e) {
      throw ProcedureException(
        'Errore imprevisto durante la riassegnazione: $e',
      );
    }
  }

  // ===========================================================================
  // HELPER METODO PRIVATO PER GESTIONE ERRORI DIO
  // ===========================================================================

  Never _handleError(DioException e, String fallbackMessage) {
    if (e.response != null) {
      final body = e.response?.data;
      final errorMessage =
          (body is Map<String, dynamic> && body.containsKey('error'))
          ? body['error'] as String
          : '$fallbackMessage (status ${e.response?.statusCode})';
      throw ProcedureException(errorMessage);
    } else {
      throw const ProcedureException(
        'Impossibile connettersi al server. Verifica la connessione.',
      );
    }
  }
}
