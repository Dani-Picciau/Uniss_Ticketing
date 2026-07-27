import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/models/login_response.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/models/ui_model.dart';
// Ricorda di correggere il path di importazione se necessario
import 'rup_user_state.dart';

class AdminManagerCubit extends Cubit<AdminManagerState> {
  // Inizializza il Cubit con lo stato di default
  AdminManagerCubit() : super(const AdminManagerState());

  void loadUserData(LoginResponse loginResponse) {
    final uiModel = AdminManagerUiModel.fromAuthResult(loginResponse);

    emit(state.copyWith(status: AdminStatus.initial, uiModel: uiModel));
  }

  // Menù in alto
  void changeTab(int index) {
    emit(state.copyWith(currentTabIndex: index, currentSidebarIndex: 0));
  }

  // Menù al lato
  void changeSidebarTab(int index) {
    emit(state.copyWith(currentSidebarIndex: index));
  }
}
