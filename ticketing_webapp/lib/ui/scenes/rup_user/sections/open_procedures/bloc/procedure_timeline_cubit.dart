import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/procedure_api.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/ui_models/procedure_timeline_ui_model.dart';
import 'procedure_timeline_state.dart';

class ProcedureTimelineCubit extends Cubit<ProcedureTimelineState> {
  final ProcedureApi _detailApi;

  ProcedureTimelineCubit({required ProcedureApi detailApi})
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
      await _detailApi.advanceToNextStep(procedureId: currentUiModel.id);

      // Ricarichiamo: il nodo corrente diventerà verde e il successivo diventerà blu!
      await fetchTimeline(currentUiModel.id, showLoading: false);
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

  // ====================== NOTE ==============================
  Future<void> saveNotes(String procedureId) async {
    if (state.selectedNodeIdForNotes == null) return;

    emit(state.copyWith(isSavingNote: true));
    try {
      await _detailApi.updateStepDetails(
        procedureId: procedureId,
        notes: state.currentNoteText,
      );

      // Opzionale ma consigliato: ricarichiamo la timeline dal server
      // per confermare che i dati siano stati salvati e aggiornare la UI
      await fetchTimeline(procedureId, showLoading: false);

      emit(state.copyWith(isSavingNote: false));
    } catch (e) {
      emit(
        state.copyWith(
          isSavingNote: false,
          errorMessage: 'Errore nel salvataggio delle note',
        ),
      );
    }
  }

  void toggleNotes({String? nodeId, String? initialText}) {
    if (state.showNotes && state.selectedNodeIdForNotes == nodeId) {
      // Se clicchiamo sullo stesso nodo già aperto, chiudiamo il pannello
      emit(
        state.copyWith(
          showNotes: false,
          clearSelectedNode: true,
          currentNoteText: '',
        ),
      );
    } else {
      // Altrimenti apriamo (o cambiamo) il pannello
      emit(
        state.copyWith(
          showNotes: true,
          selectedNodeIdForNotes: nodeId,
          currentNoteText: initialText ?? '',
        ),
      );
    }
  }

  // Aggiorna il testo mentre l'utente scrive
  void updateNoteText(String text) {
    emit(state.copyWith(currentNoteText: text));
  }
}
