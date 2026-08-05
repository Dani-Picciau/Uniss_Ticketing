import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/procedure_detail_api.dart'; // Adatta il path alla tua API
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/ui_models/procedure_timeline_ui_model.dart';
import 'procedure_timeline_state.dart';

class ProcedureTimelineCubit extends Cubit<ProcedureTimelineState> {
  final ProcedureDetailApi _detailApi;

  ProcedureTimelineCubit({required ProcedureDetailApi detailApi})
    : _detailApi = detailApi,
      super(const ProcedureTimelineState());

  Future<void> fetchTimeline(
    String procedureId, {
    bool showLoading = true,
  }) async {
    // Emettiamo "loading" SOLO se richiesto (es. al primo caricamento)
    if (showLoading) {
      emit(state.copyWith(status: ProcedureTimelineStatus.loading));
    }
    try {
      final timelineDto = await _detailApi.getFullTimeline(procedureId);

      // UI Model converte il DTO e prepara sia la pagina sia le righe
      final uiModel = ProcedureTimelineUiModel.fromTimelineDto(timelineDto);

      // Quando emettiamo il successo senza essere passati da "loading",
      // Flutter aggiorna solo le spunte modificate senza toccare lo scroll
      emit(
        state.copyWith(
          status: ProcedureTimelineStatus.success,
          uiModel: uiModel,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProcedureTimelineStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Metodo di utility se volessi svuotare il pannello di destra (es. deselezionando un item)
  void clearSelection() {
    emit(const ProcedureTimelineState(status: ProcedureTimelineStatus.initial));
  }

  // Chiama il backend per salvare la spunta e ricarica la timeline
  Future<void> toggleRequirement(String requirementName, bool isChecked) async {
    final currentUiModel = state.uiModel;
    if (currentUiModel == null) return;

    try {
      await _detailApi.updateRequirementStatus(
        procedureId: currentUiModel.id,
        requirementName: requirementName,
        satisfied: isChecked,
        userId:
            'RUP_ATTUALE', // Qui passo l'ID dell'utente loggato dal tuo SessionManager
      );

      // Ricarichiamo la timeline per avere i dati freschi dal DB!
      await fetchTimeline(currentUiModel.id, showLoading: false);
    } catch (e) {
      emit(
        state.copyWith(
          status: ProcedureTimelineStatus.error,
          errorMessage: 'Errore nel salvataggio del requisito: $e',
        ),
      );
    }
  }

  /// Avanza allo step successivo nel workflow
  Future<void> advanceStep() async {
    final currentUiModel = state.uiModel;
    if (currentUiModel == null) return;

    try {
      emit(state.copyWith(status: ProcedureTimelineStatus.loading));

      await _detailApi.advanceToNextStep(
        procedureId: currentUiModel.id,
        userId: 'RUP_ATTUALE', // ID utente loggato
      );

      // Ricarichiamo: il nodo corrente diventerà verde e il successivo diventerà blu!
      await fetchTimeline(currentUiModel.id);
    } catch (e) {
      emit(
        state.copyWith(
          status: ProcedureTimelineStatus.error,
          errorMessage:
              'Impossibile avanzare: verifica di aver spuntato tutti i requisiti.',
        ),
      );
    }
  }
}
