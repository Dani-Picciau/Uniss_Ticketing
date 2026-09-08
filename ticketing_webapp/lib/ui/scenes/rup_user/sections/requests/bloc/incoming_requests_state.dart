import 'package:ticketing_webapp/ui/scenes/rup_user/sections/requests/models/incoming_request_ui_model.dart';

enum IncomingRequestsStatus {
  loading,

  success,
  deleteSuccess,

  empty,

  error,
  deleteError,
}

class IncomingRequestsState {
  final IncomingRequestsStatus status;
  final List<ProfessorRequestUiModel> requests;
  final String? errorMessage;

  const IncomingRequestsState({
    this.status = IncomingRequestsStatus.loading,
    this.requests = const [],
    this.errorMessage,
  });

  IncomingRequestsState copyWith({
    IncomingRequestsStatus? status,
    List<ProfessorRequestUiModel>? requests,
    String? errorMessage,
  }) {
    return IncomingRequestsState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
      errorMessage: errorMessage,
    );
  }
}
