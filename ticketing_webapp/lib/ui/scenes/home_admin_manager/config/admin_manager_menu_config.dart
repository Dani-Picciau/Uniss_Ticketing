// Perché qui e non nel Cubit o nello State?
// Perché questa non è "stato" (state), è configurazione statica: non cambia
// mai a runtime, non va salvata, non serve nel Cubit. Tenerla separata rende
// più facile aggiungere/modificare voci senza toccare la logica applicativa.
//
// Quando voglio aggiungere/modificare i "campi" del side menu per un tab,
// questo è l'UNICO file che devi toccare.

import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/models/sidebar_item_data.dart';

class AdminManagerMenuConfig {
  // La chiave è l'indice del tab in SlidingMenu:
  // 0 = Scadenze, 1 = Alla firma, 2 = Procedure aperte, 3 = Nuova procedura
  static const Map<int, List<SidebarItemData>> _sidebarItemsByTab = {
    0: [
      SidebarItemData(title: 'Tutte le scadenze', iconPath: MediaConstants.all),
      SidebarItemData(
        title: 'Borse di studio',
        iconPath: MediaConstants.schoolarship,
      ),
      SidebarItemData(
        title: 'Procedure su MePa',
        iconPath: MediaConstants.schoolarship,
      ),
      SidebarItemData(
        title: 'Procedure fuori MePa',
        iconPath: MediaConstants.schoolarship,
      ),
    ],
    1: [
      SidebarItemData(title: 'Tutti i documenti', iconPath: MediaConstants.all),
      SidebarItemData(
        title: 'Borse di studio',
        iconPath: MediaConstants.schoolarship,
      ),
      SidebarItemData(
        title: 'Procedure su MePa',
        iconPath: MediaConstants.schoolarship,
      ),
      SidebarItemData(
        title: 'Procedure fuori MePa',
        iconPath: MediaConstants.schoolarship,
      ),
    ],
    2: [
      SidebarItemData(
        title: 'Tutte le procedure',
        iconPath: MediaConstants.all,
      ),
      SidebarItemData(
        title: 'Borse di studio',
        iconPath: MediaConstants.schoolarship,
      ),
      SidebarItemData(
        title: 'Procedure su MePa',
        iconPath: MediaConstants.schoolarship,
      ),
      SidebarItemData(
        title: 'Procedure fuori MePa',
        iconPath: MediaConstants.schoolarship,
      ),
    ],
    3: [
      SidebarItemData(
        title: 'Nuova borsa di studio',
        iconPath: MediaConstants.schoolarship,
      ),
      SidebarItemData(
        title: 'Nuova procedura su MePa',
        iconPath: MediaConstants.schoolarship,
      ),
      SidebarItemData(
        title: 'Nuova procedura fuori MePa',
        iconPath: MediaConstants.schoolarship,
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
