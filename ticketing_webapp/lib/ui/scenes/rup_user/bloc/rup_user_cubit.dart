import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ticketing_webapp/features/models/login_response.dart';
import 'package:ticketing_webapp/ui/scenes/models/ui_models/dashboard_ui_model.dart';
// Ricorda di correggere il path di importazione se necessario
import 'rup_user_state.dart';

class AdminManagerCubit extends Cubit<AdminManagerState> {
  // Inizializza il Cubit con lo stato di default
  AdminManagerCubit() : super(const AdminManagerState());

  void loadUserData(LoginResponse loginResponse) {
    final uiModel = DashboardUserUiModel.fromAuthResult(loginResponse);

    emit(state.copyWith(status: AdminStatus.initial, uiModel: uiModel));
  }

  // Menù in alto
  void changeTab(int index) {
    emit(
      state.copyWith(
        currentTabIndex: index,
        currentSidebarIndex: 0,
        targetProcedureId:
            '', // Pulisco l'Id per evitare di mantenere la timeline attiva cambiando le tab laterali e orizzontali
      ),
    );
  }

  // Menù al lato
  void changeSidebarTab(int index) {
    emit(state.copyWith(currentSidebarIndex: index, targetProcedureId: ''));
  }

  void jumpToProcedureTimeline(String procedureId) {
    emit(
      state.copyWith(
        currentTabIndex: 3, // L'indice del tab "Procedure aperte"
        currentSidebarIndex: 0, //
        targetProcedureId: procedureId, // Passiamo l'ID
      ),
    );
  }

  // Funzione per ripulire l'ID quando usciamo dalla timeline arrivando dalle scadenze
  void clearTargetProcedure() {
    emit(state.copyWith(targetProcedureId: ''));
  }

  // Emetto la nuova data una volta che viene cambiata per fare in modo che non si resetti ogni volta che cambio sezione
  void updateDeadlineDate(DateTime newDate) {
    emit(state.copyWith(selectedDeadlineDate: newDate));
  }

  // Emetto il tipo di formato del calendario per fare in modo che non si resetti ogni volta che cambio sezione
  void updateCalendarFormat(CalendarFormat newFormat) {
    emit(state.copyWith(calendarFormat: newFormat));
  }
}
