import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/ui_models/procedure_timeline_ui_model.dart';

enum ProcedureTimelineStatus { initial, loading, success, error }

class ProcedureTimelineState {
  final ProcedureTimelineStatus status;
  final ProcedureTimelineUiModel? uiModel;
  final String? errorMessage;

  const ProcedureTimelineState({
    this.status = ProcedureTimelineStatus.initial,
    this.uiModel,
    this.errorMessage,
  });

  ProcedureTimelineState copyWith({
    ProcedureTimelineStatus? status,
    ProcedureTimelineUiModel? uiModel,
    String? errorMessage,
  }) {
    return ProcedureTimelineState(
      status: status ?? this.status,
      uiModel: uiModel ?? this.uiModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
