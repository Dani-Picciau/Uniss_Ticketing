import 'package:ticketing_webapp/ui/scenes/rup_user/models/ui_model.dart';

// Definiamo le fasi della pagina
enum AdminStatus { loading, initial, error }

class AdminManagerState {
  final AdminStatus status;
  final int currentTabIndex;
  final int currentSidebarIndex;
  final AdminManagerUiModel? uiModel;
  final String? targetProcedureId; // Id per passare dalle scadenze alla timeline in Procedure aperte

  const AdminManagerState({
    this.status = AdminStatus.loading, // Partiamo in caricamento
    this.currentTabIndex = 0,
    this.currentSidebarIndex = 0,
    this.uiModel,
    this.targetProcedureId,
  });

  AdminManagerState copyWith({
    AdminStatus? status,
    int? currentTabIndex,
    int? currentSidebarIndex,
    AdminManagerUiModel? uiModel,
    String? targetProcedureId,
  }) {
    return AdminManagerState(
      status: status ?? this.status,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      currentSidebarIndex: currentSidebarIndex ?? this.currentSidebarIndex,
      uiModel: uiModel ?? this.uiModel,
      targetProcedureId: targetProcedureId == ''
          ? null
          : (targetProcedureId ?? this.targetProcedureId),
    );
  }
}
