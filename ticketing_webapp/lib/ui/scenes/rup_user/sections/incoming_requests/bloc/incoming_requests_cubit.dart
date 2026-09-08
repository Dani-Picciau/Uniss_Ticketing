import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/professor_request_api.dart';
import 'package:ticketing_webapp/ui/scenes/models/ui_models/professor_request_ui_model.dart';
import 'incoming_requests_state.dart';

class IncomingRequestsCubit extends Cubit<IncomingRequestsState> {
  final ProfessorRequestApi _api;

  IncomingRequestsCubit({required ProfessorRequestApi api})
    : _api = api,
      super(const IncomingRequestsState());

  Future<void> fetchIncomingRequests(String statusType) async {
    try {
      final rawRequests = await _api.getRequestsByStatus(statusType);

      if (rawRequests.isEmpty) {
        emit(state.copyWith(status: IncomingRequestsStatus.empty));
        return;
      }

      // Trasformo i DTO Freezed nei modelli per la UI
      final uiRequests = rawRequests
          .map((summary) => ProfessorRequestUiModel.fromSummary(summary))
          .toList();

      emit(
        state.copyWith(
          status: IncomingRequestsStatus.success,
          requests: uiRequests,
        ),
      );
    } on ProfessorRequestException catch (e) {
      emit(
        state.copyWith(
          status: IncomingRequestsStatus.error,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: IncomingRequestsStatus.error,
          errorMessage:
              'Errore imprevisto durante il caricamento delle richieste.',
        ),
      );
    }
  }
}
