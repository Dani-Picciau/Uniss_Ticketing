import 'package:table_calendar/table_calendar.dart';
import 'package:ticketing_webapp/ui/scenes/models/ui_models/dashboard_ui_model.dart';

// Definiamo le fasi della pagina
enum AdminStatus { loading, initial, error }

class AdminManagerState {
  final AdminStatus status;
  final int currentTabIndex;
  final int currentSidebarIndex;
  final DashboardUserUiModel? uiModel;

  final String?
  targetProcedureId; // Id da assegnare alla procedura per passare dalla sezione delle scadenze alla sezione delle procedure aperte nella timeline
  final DateTime?
  selectedDeadlineDate; // Salvo la variabile della data nello stato per salvare la data selezionata nel calendario anche se cambio tab laterale
  final CalendarFormat calendarFormat;

  const AdminManagerState({
    this.status = AdminStatus.loading, // Partiamo in caricamento
    this.currentTabIndex = 0,
    this.currentSidebarIndex = 0,
    this.uiModel,
    this.targetProcedureId,
    this.selectedDeadlineDate,
    this.calendarFormat = CalendarFormat.week,
  });

  AdminManagerState copyWith({
    AdminStatus? status,
    int? currentTabIndex,
    int? currentSidebarIndex,
    DashboardUserUiModel? uiModel,
    String? targetProcedureId,
    DateTime? selectedDeadlineDate,
    CalendarFormat? calendarFormat,
  }) {
    return AdminManagerState(
      status: status ?? this.status,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      currentSidebarIndex: currentSidebarIndex ?? this.currentSidebarIndex,
      uiModel: uiModel ?? this.uiModel,
      targetProcedureId: targetProcedureId == ''
          ? null
          : (targetProcedureId ?? this.targetProcedureId),
      selectedDeadlineDate: selectedDeadlineDate ?? this.selectedDeadlineDate,
      calendarFormat: calendarFormat ?? this.calendarFormat,
    );
  }
}
