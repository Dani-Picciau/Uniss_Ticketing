import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/ui_models/procedure_timeline_ui_model.dart';

enum ProcedureTimelineStatus { initial, loading, success, error }

class ProcedureTimelineState {
  final ProcedureTimelineStatus status;
  final ProcedureTimelineUiModel? uiModel;
  final String? errorMessage;

  // Note
  final bool showNotes;
  final String? selectedNodeIdForNotes;
  final String currentNoteText;
  final bool isSavingNote;

  const ProcedureTimelineState({
    this.status = ProcedureTimelineStatus.initial,
    this.uiModel,
    this.errorMessage,

    this.showNotes = false,
    this.selectedNodeIdForNotes,
    this.currentNoteText = '',
    this.isSavingNote = false,
  });

  ProcedureTimelineState copyWith({
    ProcedureTimelineStatus? status,
    ProcedureTimelineUiModel? uiModel,
    String? errorMessage,

    bool? showNotes,
    String? selectedNodeIdForNotes,
    bool clearSelectedNode = false, // Trucco per resettare a null
    String? currentNoteText,
    bool? isSavingNote,
  }) {
    return ProcedureTimelineState(
      status: status ?? this.status,
      uiModel: uiModel ?? this.uiModel,
      errorMessage: errorMessage ?? this.errorMessage,
      showNotes: showNotes ?? this.showNotes,

      // Se clearSelectedNode è true lo forziamo a null, altrimenti prendiamo il nuovo o il vecchio
      selectedNodeIdForNotes: clearSelectedNode
          ? null
          : (selectedNodeIdForNotes ?? this.selectedNodeIdForNotes),
      currentNoteText: currentNoteText ?? this.currentNoteText,
      isSavingNote: isSavingNote ?? this.isSavingNote,
    );
  }
}
