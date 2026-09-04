import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/models/sidebar_item_data.dart';

class AdminManagerMenuConfig {
  // La chiave è l'indice del tab in SlidingMenu:
  // 0 = Scadenze, 1 = Alla firma, 2 = Procedure aperte, 3 = Nuova procedura
  static const Map<int, List<SidebarItemData>> _sidebarItemsByTab = {
    0: [
      SidebarItemData(
        id: 0,
        title: 'Tutte le scadenze',
        iconPath: MediaConstants.all,
      ),
      SidebarItemData(
        id: 1,
        title: 'Borse di studio',
        iconPath: MediaConstants.arrowDown,
        subItems: [
          SidebarItemData(
            id: 11,
            title: 'Nuove borse',
            iconPath: MediaConstants.schoolarship,
          ),
          SidebarItemData(
            id: 12,
            title: 'Rinnovo borse',
            iconPath: MediaConstants.schoolarship,
          ),
        ],
      ),
      SidebarItemData(
        id: 2,
        title: 'Procedure su MePa',
        iconPath: MediaConstants.arrowDown,
        subItems: [
          SidebarItemData(
            id: 21,
            title: 'Beni di consumo',
            iconPath: MediaConstants.consumerGoods,
          ),
          SidebarItemData(
            id: 22,
            title: 'Attrezzature',
            iconPath: MediaConstants.equipment,
          ),
          SidebarItemData(
            id: 23,
            title: 'Servizi',
            iconPath: MediaConstants.services,
          ),
        ],
      ),
      SidebarItemData(
        id: 3,
        title: 'Procedure fuori MePa',
        iconPath: MediaConstants.arrowDown,
        subItems: [
          SidebarItemData(
            id: 31,
            title: 'Beni di consumo',
            iconPath: MediaConstants.consumerGoods,
          ),
          SidebarItemData(
            id: 32,
            title: 'Pubblicazioni',
            iconPath: MediaConstants.pubblication,
          ),
        ],
      ),
    ],

    1: [
      SidebarItemData(
        id: 0,
        title: 'Tutte le richieste',
        iconPath: MediaConstants.all,
      ),
    ],

    2: [
      SidebarItemData(
        id: 0,
        title: 'Tutti i documenti',
        iconPath: MediaConstants.all,
      ),
      SidebarItemData(
        id: 1,
        title: 'Borse di studio',
        iconPath: MediaConstants.arrowDown,
        subItems: [
          SidebarItemData(
            id: 11,
            title: 'Nuove borse',
            iconPath: MediaConstants.schoolarship,
          ),
          SidebarItemData(
            id: 12,
            title: 'Rinnovo borse',
            iconPath: MediaConstants.schoolarship,
          ),
        ],
      ),
      SidebarItemData(
        id: 2,
        title: 'Procedure su MePa',
        iconPath: MediaConstants.arrowDown,
        subItems: [
          SidebarItemData(
            id: 21,
            title: 'Beni di consumo',
            iconPath: MediaConstants.consumerGoods,
          ),
          SidebarItemData(
            id: 22,
            title: 'Attrezzature',
            iconPath: MediaConstants.equipment,
          ),
          SidebarItemData(
            id: 23,
            title: 'Servizi',
            iconPath: MediaConstants.services,
          ),
        ],
      ),
      SidebarItemData(
        id: 3,
        title: 'Procedure fuori MePa',
        iconPath: MediaConstants.arrowDown,
        subItems: [
          SidebarItemData(
            id: 31,
            title: 'Beni di consumo',
            iconPath: MediaConstants.consumerGoods,
          ),
          SidebarItemData(
            id: 32,
            title: 'Pubblicazioni',
            iconPath: MediaConstants.pubblication,
          ),
        ],
      ),
    ],

    3: [
      SidebarItemData(
        id: 0,
        title: 'Tutte le procedure',
        iconPath: MediaConstants.all,
      ),
      SidebarItemData(
        id: 1,
        title: 'Borse di studio',
        iconPath: MediaConstants.arrowDown,
        subItems: [
          SidebarItemData(
            id: 11,
            title: 'Nuove borse',
            iconPath: MediaConstants.schoolarship,
          ),
          SidebarItemData(
            id: 12,
            title: 'Rinnovo borse',
            iconPath: MediaConstants.schoolarship,
          ),
        ],
      ),
      SidebarItemData(
        id: 2,
        title: 'Procedure su MePa',
        iconPath: MediaConstants.arrowDown,
        subItems: [
          SidebarItemData(
            id: 21,
            title: 'Beni di consumo',
            iconPath: MediaConstants.consumerGoods,
          ),
          SidebarItemData(
            id: 22,
            title: 'Attrezzature',
            iconPath: MediaConstants.equipment,
          ),
          SidebarItemData(
            id: 23,
            title: 'Servizi',
            iconPath: MediaConstants.services,
          ),
        ],
      ),
      SidebarItemData(
        id: 3,
        title: 'Procedure fuori MePa',
        iconPath: MediaConstants.arrowDown,
        subItems: [
          SidebarItemData(
            id: 31,
            title: 'Beni di consumo',
            iconPath: MediaConstants.consumerGoods,
          ),
          SidebarItemData(
            id: 32,
            title: 'Pubblicazioni',
            iconPath: MediaConstants.pubblication,
          ),
        ],
      ),
    ],

    4: [
      SidebarItemData(
        id: 0,
        title: 'Nuova borsa di studio',
        iconPath: MediaConstants.newProcedure,
      ),
      SidebarItemData(
        id: 1,
        title: 'Nuova procedura su MePa',
        iconPath: MediaConstants.newProcedure,
      ),
      SidebarItemData(
        id: 2,
        title: 'Nuova procedura fuori MePa',
        iconPath: MediaConstants.newProcedure,
      ),
    ],
  };

  /// Ritorna le voci del side menu per il tab indicato.
  /// Se il tab non è mappato, ritorna una lista vuota invece di esplodere:
  /// meglio un menu vuoto che un crash.
  static List<SidebarItemData> getSidebarItems(int tabIndex) {
    return _sidebarItemsByTab[tabIndex] ?? const [];
  }
}
