import 'package:ticketing_webapp/ui/scenes/models/ui_models/professor_request_ui_model.dart';

enum ProfessorRequestsStatus {
  loading,

  success,
  deleteSuccess,

  empty,

  error,
  deleteError,
}

class ProfessorRequestsState {
  final ProfessorRequestsStatus status;
  final List<ProfessorRequestUiModel> requests;
  final String? errorMessage;

  const ProfessorRequestsState({
    this.status = ProfessorRequestsStatus.loading,
    this.requests = const [],
    this.errorMessage,
  });

  ProfessorRequestsState copyWith({
    ProfessorRequestsStatus? status,
    List<ProfessorRequestUiModel>? requests,
    String? errorMessage,
  }) {
    return ProfessorRequestsState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
      errorMessage: errorMessage,
    );
  }
}
