import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/open_procedure_list/models/requests/procedure_summary/procedure_summary.dart';

enum ProcedureListStatus { success, loading, error, empty }

class ProcedureListState {
  final ProcedureListStatus status;
  final List<ProcedureSummary> procedures;
  final String? errorMessage;

  const ProcedureListState({
    this.status = ProcedureListStatus.loading,
    this.procedures = const [],
    this.errorMessage,
  });

  ProcedureListState copyWith({
    ProcedureListStatus? status,
    List<ProcedureSummary>? procedures,
    String? errorMessage,
  }) {
    return ProcedureListState(
      status: status ?? this.status,
      procedures: procedures ?? this.procedures,
      errorMessage: errorMessage,
    );
  }
}
