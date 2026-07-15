import 'package:ticketing_webapp/ui/scenes/home_admin_manager/models/ui_model.dart';

// Definiamo le fasi della pagina
enum AdminStatus { loading, initial, error }

class AdminManagerState {
  final AdminStatus status;
  final int currentTabIndex; 
  final int currentSidebarIndex; 
  final AdminManagerUiModel? uiModel;

  const AdminManagerState({
    this.status = AdminStatus.loading, // Partiamo in caricamento
    this.currentTabIndex = 0,
    this.currentSidebarIndex = 0,
    this.uiModel,
  });

  AdminManagerState copyWith({
    AdminStatus? status,
    int? currentTabIndex, 
    int? currentSidebarIndex,
    AdminManagerUiModel? uiModel,
  }) {
    return AdminManagerState(
      status: status ?? this.status,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      currentSidebarIndex: currentSidebarIndex ?? this.currentSidebarIndex,
      uiModel: uiModel ?? this.uiModel,
    );
  }
}