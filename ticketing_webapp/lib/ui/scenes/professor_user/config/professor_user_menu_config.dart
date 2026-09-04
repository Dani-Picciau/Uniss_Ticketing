import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/side_menu/sidebar_item_data.dart';

class ProfessorUserMenuConfig {
  /// Ritorna le voci del side menu per il tab indicato.
  /// Accetta il parametro `isDirector` per mostrare voci aggiuntive.
  static List<SidebarItemData> getSidebarItems(
    int tabIndex, {
    required bool isDirector,
  }) {
    switch (tabIndex) {
      case 0:
      case 1:
      case 2:
        return [
          // Questo elemento viene inserito nella lista SOLO se isDirector è true
          if (isDirector)
            const SidebarItemData(
              id: 0,
              title: 'Tutte le procedure',
              iconPath: MediaConstants.all,
            ),
          const SidebarItemData(
            id: 1,
            title: 'Le mie procedure',
            iconPath: MediaConstants.personalProcedures,
          ),
        ];

      case 3:
        return [
          const SidebarItemData(
            id: 0,
            title: 'Creazione nuova richiesta',
            iconPath: MediaConstants.newProcedure,
          ),
        ];

      default:
        return const [];
    }
  }
}
