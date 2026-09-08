import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/side_menu/sidebar_item_data.dart';

class ProfessorUserMenuConfig {
  static List<SidebarItemData> getSidebarItems(
    int tabIndex, {
    required bool isDirector,
  }) {
    switch (tabIndex) {
      case 0:
      case 2:
        return [
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

      case 1:
        return [
          if (isDirector)
            const SidebarItemData(
              id: 0,
              title: 'Tutte le richieste',
              iconPath: MediaConstants.all,
            ),
          const SidebarItemData(
            id: 1,
            title: 'Le mie richieste',
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
