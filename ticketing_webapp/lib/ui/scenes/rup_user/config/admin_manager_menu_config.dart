// Perché qui e non nel Cubit o nello State?
// Perché questa non è "stato" (state), è configurazione statica: non cambia
// mai a runtime, non va salvata, non serve nel Cubit. Tenerla separata rende
// più facile aggiungere/modificare voci senza toccare la logica applicativa.
//
// Quando voglio aggiungere/modificare i "campi" del side menu per un tab,
// questo è l'UNICO file che bisogna modificare toccare.
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/side_menu/sidebar_item_data.dart';

class AdminManagerMenuConfig {
  static List<SidebarItemData> getSidebarItems(
    int tabIndex, {
    required bool isRUP,
  }) {
    switch (tabIndex) {
      case 0:
        return [
          const SidebarItemData(
            id: 0,
            title: 'Tutte le scadenze',
            iconPath: MediaConstants.all,
          ),
          const SidebarItemData(
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
          const SidebarItemData(
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
          const SidebarItemData(
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
        ];
      case 1:
        return [
          if (isRUP)
            const SidebarItemData(
              id: 0,
              title: 'Richieste in attesa',
              iconPath: MediaConstants.all,
            ),
          if (!isRUP)
            const SidebarItemData(
              id: 2,
              title: 'Richieste assegnate',
              iconPath: MediaConstants.assignedRequests,
            ),
          const SidebarItemData(
            id: 1,
            title: 'Richieste prese in carico',
            iconPath: MediaConstants.takingCharge,
          ),
          if (isRUP)
            const SidebarItemData(
              id: 2,
              title: 'Richieste assegnate',
              iconPath: MediaConstants.assignedRequests,
            ),
          const SidebarItemData(
            id: 3,
            title: 'Richieste assolte',
            iconPath: MediaConstants.history,
          ),
        ];
      case 2:
        return [
          const SidebarItemData(
            id: 0,
            title: 'Tutti i documenti',
            iconPath: MediaConstants.all,
          ),
          const SidebarItemData(
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
          const SidebarItemData(
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
          const SidebarItemData(
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
        ];
      case 3:
        return [
          const SidebarItemData(
            id: 0,
            title: 'Tutte le procedure',
            iconPath: MediaConstants.all,
          ),
          const SidebarItemData(
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
          const SidebarItemData(
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
          const SidebarItemData(
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
        ];
      case 4:
        return [
          const SidebarItemData(
            id: 0,
            title: 'Nuova borsa di studio',
            iconPath: MediaConstants.newProcedure,
          ),
          const SidebarItemData(
            id: 1,
            title: 'Nuova procedura su MePa',
            iconPath: MediaConstants.newProcedure,
          ),
          const SidebarItemData(
            id: 2,
            title: 'Nuova procedura fuori MePa',
            iconPath: MediaConstants.newProcedure,
          ),
        ];
      default:
        return const [];
    }
  }
}
