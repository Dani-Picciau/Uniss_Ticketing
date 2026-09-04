import 'package:ticketing_webapp/ui/scenes/models/ui_model.dart';

enum ProfessorStatus { loading, initial, error }

class ProfessorUserState {
  final ProfessorStatus status;
  final int currentTabIndex;
  final int currentSidebarIndex;
  final DashboardUserUiModel? uiModel;

  const ProfessorUserState({
    this.status = ProfessorStatus.loading, // Partiamo in caricamento
    this.currentTabIndex = 0,
    this.currentSidebarIndex = 0,
    this.uiModel,
  });

  ProfessorUserState copyWith({
    ProfessorStatus? status,
    int? currentTabIndex,
    int? currentSidebarIndex,
    DashboardUserUiModel? uiModel,
  }) {
    return ProfessorUserState(
      status: status ?? this.status,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      currentSidebarIndex: currentSidebarIndex ?? this.currentSidebarIndex,
      uiModel: uiModel ?? this.uiModel,
    );
  }
}
