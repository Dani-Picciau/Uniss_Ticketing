import 'package:ticketing_webapp/ui/scenes/models/ui_models/professor_request_ui_model.dart';

enum PendingRequestsStatus {
  loading,

  success,
  deleteSuccess,

  empty,

  error,
  deleteError,
}

class PendingRequestsState {
  final PendingRequestsStatus status;
  final List<ProfessorRequestUiModel> requests;
  final String? errorMessage;

  const PendingRequestsState({
    this.status = PendingRequestsStatus.loading,
    this.requests = const [],
    this.errorMessage,
  });

  PendingRequestsState copyWith({
    PendingRequestsStatus? status,
    List<ProfessorRequestUiModel>? requests,
    String? errorMessage,
  }) {
    return PendingRequestsState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
      errorMessage: errorMessage,
    );
  }
}
