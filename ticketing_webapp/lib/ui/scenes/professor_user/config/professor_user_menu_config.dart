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
          const SidebarItemData(
            id: 0,
            title: 'Le mie procedure',
            iconPath: MediaConstants.all,
          ),
          if (isDirector)
            const SidebarItemData(
              id: 1,
              title: 'Tutte le procedure',
              iconPath: MediaConstants.personalProcedures,
            ),
        ];

      case 1:
        return [
          const SidebarItemData(
            id: 0,
            title: 'Richieste in attesa',
            iconPath: MediaConstants.all,
          ),
          const SidebarItemData(
            id: 1,
            title: 'Richieste prese in carico',
            iconPath: MediaConstants.takingCharge,
          ),
          if (isDirector)
            const SidebarItemData(
              id: 2,
              title: 'Tutte le richieste',
              iconPath: MediaConstants.arrowDown,
              subItems: [
                SidebarItemData(
                  id: 21,
                  title: 'In attesa',
                  iconPath: MediaConstants.personalProcedures,
                ),
                SidebarItemData(
                  id: 22,
                  title: 'Prese in carico',
                  iconPath: MediaConstants.takingCharge,
                ),
              ],
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
