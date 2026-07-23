// Utilizza api_client.dart per effettuare le chiamate HTTPimport 'package:ticketing_webapp/data/models/procedura_request.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ticketing_webapp/constants/api_constants.dart';
import 'package:ticketing_webapp/data/network/api_client.dart';
import 'package:ticketing_webapp/data/storage/session_manager.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/request/procedure_request.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/response/administrator_response/administrator_response.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/response/professor_response/professor_response.dart';

class ProcedureRepositoryException implements Exception {
  final String message;
  const ProcedureRepositoryException(this.message);

  @override
  String toString() => message;
}

class ProcedureRepository {
  final ApiClient _apiClient;
  final SessionManager _sessionManager;

  ProcedureRepository({
    required this._apiClient,
    required this._sessionManager,
  });

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
      if (e.response != null) {
        final body = e.response?.data;
        final errorMessage =
            (body is Map<String, dynamic> && body.containsKey('error'))
            ? body['error'] as String
            : 'Errore nel recupero dei docenti dal server';

        throw ProcedureRepositoryException(errorMessage);
      } else {
        throw const ProcedureRepositoryException(
          'Impossibile connettersi al server. Verifica la connessione.',
        );
      }
    } catch (e) {
      throw ProcedureRepositoryException(
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
      if (e.response != null) {
        final body = e.response?.data;
        final errorMessage =
            (body is Map<String, dynamic> && body.containsKey('error'))
            ? body['error'] as String
            : 'Errore nel recupero dei docenti dal server';

        throw ProcedureRepositoryException(errorMessage);
      } else {
        throw const ProcedureRepositoryException(
          'Impossibile connettersi al server. Verifica la connessione.',
        );
      }
    } catch (e) {
      throw ProcedureRepositoryException(
        'Errore imprevisto durante il recupero dei docenti: $e',
      );
    }
  }

  Future<void> createProcedure(ProcedureRequest request) async {
    try {
      final token = await _sessionManager.getToken();
      await _apiClient.dio.post(
        ApiConstants.createProcedure,
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      debugPrint('STATUS: ${e.response?.statusCode}');
      debugPrint('BODY: ${e.response?.data}');
      final body = e.response?.data;
      final errorMessage =
          (body is Map<String, dynamic> && body.containsKey('error'))
          ? body['error'] as String
          : 'Errore nel server durante la creazione (status ${e.response?.statusCode})';
      throw ProcedureRepositoryException(errorMessage);
    } catch (e) {
      debugPrint('ERRORE GENERICO: $e');
      throw ProcedureRepositoryException('Errore imprevisto: $e');
    }
  }
}
