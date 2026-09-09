import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/professor_request_api.dart';
import 'package:ticketing_webapp/ui/scenes/models/ui_models/professor_request_ui_model.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/bloc/professor_requests_state.dart';

class ProfessorRequestsCubit extends Cubit<ProfessorRequestsState> {
  final ProfessorRequestApi _api;

  ProfessorRequestsCubit({required ProfessorRequestApi api})
    : _api = api,
      super(const ProfessorRequestsState());

  Future<void> fetchPendingRequests(String status) async {
    try {
      final rawRequests = await _api.getRequestsByStatus(status);

      if (rawRequests.isEmpty) {
        emit(state.copyWith(status: ProfessorRequestsStatus.empty));
        return;
      }

      final uiRequests = rawRequests
          .map((summary) => ProfessorRequestUiModel.fromSummary(summary))
          .toList();

      emit(
        state.copyWith(
          status:
              ProfessorRequestsStatus.success, // 3. CORRETTO: Usa l'enum giusto
          requests: uiRequests,
        ),
      );
    } on ProfessorRequestException catch (e) {
      emit(
        state.copyWith(
          status: ProfessorRequestsStatus.error,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfessorRequestsStatus.error,
          errorMessage:
              'Errore imprevisto durante il caricamento delle richieste.',
        ),
      );
    }
  }

  Future<void> fetchMyRequestsByStatus(String status) async {
    try {
      final rawRequests = await _api.getMyRequestsByStatus(status);

      if (rawRequests.isEmpty) {
        emit(state.copyWith(status: ProfessorRequestsStatus.empty));
        return;
      }

      final uiRequests = rawRequests
          .map((summary) => ProfessorRequestUiModel.fromSummary(summary))
          .toList();

      emit(
        state.copyWith(
          status: ProfessorRequestsStatus.success,
          requests: uiRequests,
        ),
      );
    } on ProfessorRequestException catch (e) {
      emit(
        state.copyWith(
          status: ProfessorRequestsStatus.error,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfessorRequestsStatus.error,
          errorMessage:
              'Errore imprevisto durante il caricamento delle richieste.',
        ),
      );
    }
  }

  Future<void> deleteRequest(String procedureId) async {
    // Emetto lo stato di loading perché sono in success
    emit(state.copyWith(status: ProfessorRequestsStatus.loading));

    try {
      // Chiamata all'API
      _api.deleteRequest(procedureId);

      // Se ha successo, filtriamo la lista attuale rimuovendo quella eliminata
      final updatedList = state.requests
          .where((procedure) => procedure.id != procedureId)
          .toList();

      // Aggiorniamo lo stato con la nuova lista e il successo
      emit(
        state.copyWith(
          status: ProfessorRequestsStatus.deleteSuccess,
          requests:
              updatedList, // La lista aggiornata (senza la procedura eliminata)
        ),
      );
    } catch (e) {
      // Gestione errore
      emit(
        state.copyWith(
          status: ProfessorRequestsStatus.deleteError,
          errorMessage: '$e',
        ),
      );
    }
  }
}
