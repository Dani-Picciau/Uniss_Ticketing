import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/ui_models/procedure_timeline_ui_model.dart';

enum ProcedureTimelineStatus { initial, loading, success, error }

class ProcedureTimelineState {
  final ProcedureTimelineStatus status;
  final ProcedureTimelineUiModel? uiModel;
  final String? errorMessage;
  final bool showNotes;

  const ProcedureTimelineState({
    this.status = ProcedureTimelineStatus.initial,
    this.uiModel,
    this.errorMessage,
    this.showNotes = false,
  });

  ProcedureTimelineState copyWith({
    ProcedureTimelineStatus? status,
    ProcedureTimelineUiModel? uiModel,
    String? errorMessage,
    bool? showNotes,
  }) {
    return ProcedureTimelineState(
      status: status ?? this.status,
      uiModel: uiModel ?? this.uiModel,
      errorMessage: errorMessage ?? this.errorMessage,
      showNotes: showNotes ?? this.showNotes, 
    );
  }
}
