import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/models/login_response.dart';
import 'package:ticketing_webapp/ui/scenes/models/ui_models/dashboard_ui_model.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/bloc/professor_user_state.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/config/professor_user_menu_config.dart';

class ProfessorUserCubit extends Cubit<ProfessorUserState> {
  // Inizializza il Cubit con lo stato di default
  ProfessorUserCubit() : super(const ProfessorUserState());

  void loadUserData(LoginResponse loginResponse) {
    final uiModel = DashboardUserUiModel.fromAuthResult(loginResponse);

    //Dato che professorUserScreen viene usato sia per il direttore che per i docenti, a seconda del ruolo che ricopro lo slide menu deve mostrare differenti sideMenu.
    final isDirector = uiModel.roles.contains('DIRETTORE');

    // Gli elementi del sideMenu rimangono costanti, ciò che cambia è quale elemento considero come "primo" nella lista. Quindi se l'utente non è il direttore il primo elemento nella lista non è "Tutte le procedure" (0) ma solo "Le mie procedure" (1).
    // Quindi, recupero gli elementi nella lista specificando se l'utente sia o non sia il direttore.
    final initialItems = ProfessorUserMenuConfig.getSidebarItems(
      0,
      isDirector: isDirector,
    );

    // Usando "initialItems.first.id" ci assicuriamo che se la sezione "Tutte le procedure" (0) viene nascosta perche non siamo direttori, "Le mie procedure" (1) venga trattato come primo elemento visibile e passato al cubit come indice di inizio per essere colorato come attivo.
    final startingIndex = initialItems.isNotEmpty ? initialItems.first.id : 0;

    emit(
      state.copyWith(
        status: ProfessorStatus.initial,
        uiModel: uiModel,
        currentSidebarIndex: startingIndex,
      ),
    );
  }

  // Menù in alto
  // Applichiamo la stessa logica ogni qual volta l'utente richiama la funzione per cambiare tab
  void changeTab(int index) {
    final isDirector = state.uiModel?.roles.contains('DIRETTORE') ?? false;

    // Recuperiamo il menu per il nuovo Tab cliccato
    final newItems = ProfessorUserMenuConfig.getSidebarItems(
      index,
      isDirector: isDirector,
    );
    final startingIndex = newItems.isNotEmpty ? newItems.first.id : 0;

    emit(
      state.copyWith(
        currentTabIndex: index,
        currentSidebarIndex: startingIndex,
      ),
    );
  }

  // Menù al lato
  void changeSidebarTab(int index) {
    emit(state.copyWith(currentSidebarIndex: index));
  }
}
