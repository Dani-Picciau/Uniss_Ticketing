import 'package:flutter_bloc/flutter_bloc.dart';
// Ricorda di correggere il path di importazione se necessario
import 'admin_manager_state.dart';

class AdminManagerCubit extends Cubit<AdminManagerState> {
  // Inizializza il Cubit con lo stato di default
  AdminManagerCubit() : super(const AdminManagerState());

  // Menù in alto
  void changeTab(int index) {
    emit(state.copyWith(currentTabIndex: index, currentSidebarIndex: 0));
  }

  // Menù al lato
  void changeSidebarTab(int index) {
    emit(state.copyWith(currentSidebarIndex: index));
  }
}
