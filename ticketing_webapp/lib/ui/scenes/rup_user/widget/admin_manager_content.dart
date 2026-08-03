// Questo widget è il contenuto vero e proprio da mostrare nel riquadro
// bianco a destra.
//
// Serve un Widget dedicato per fare in modo che AdminManagerScreen si
// occupi SOLO di layout (dove vanno le cose sullo schermo), mentre
// questo file si occupa  SOLO di "quale contenuto corrisponde a quale
// selezione".
// Quando in futuro aggiungerò contenuti reali, lavorerò quasi sempre solo qui dentro.

import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/new_on_mepa.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/new_outside_mepa.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/new_scholarship.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/all/open_procedures_all.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/on_mepa/consumer_goods/open_mepa_consumer_goods.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/on_mepa/equipment/open_mepa_equipment.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/on_mepa/services/open_mepa_services.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/outside_mepa/consumer_goods/open_oMepa_consumer_goods.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/scholaship/open_scholaship.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class AdminManagerContent extends StatelessWidget {
  final int tabIndex;
  final int sidebarIndex;
  final String rupId;

  const AdminManagerContent({
    super.key,
    required this.tabIndex,
    required this.sidebarIndex,
    required this.rupId,
  });

  @override
  Widget build(BuildContext context) {
    switch (tabIndex) {
      case 0:
        return _scadenzeContent(sidebarIndex);
      case 1:
        return _allaFirmaContent(sidebarIndex);
      case 2:
        return _procedureAperteContent(sidebarIndex);
      case 3:
        return _nuovaProceduraContent(sidebarIndex);
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 0: Scadenze -------------------------------------------------
  Widget _scadenzeContent(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return const _Placeholder(text: 'Tutte le scadenze');
      case 1:
        return const _Placeholder(text: 'Scadenze borse di studio');
      case 21:
        return const _Placeholder(text: 'Scadenze beni di consumo su MePa');
      case 22:
        return const _Placeholder(text: 'Scadenze attrezzature su MePa');
      case 23:
        return const _Placeholder(text: 'Scadenze servizi su MePa');
      case 31:
        return const _Placeholder(text: 'Scadenze beni di consumo fuori MePa');
      case 32:
        return const _Placeholder(text: 'Scadenze pubblicazioni fuori MePa');
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 1: Alla firma ------------------------------------------------
  Widget _allaFirmaContent(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return const _Placeholder(text: 'Tutti i documenti alla firma');
      case 1:
        return const _Placeholder(text: 'Borse di studio alla firma');
      case 21:
        return const _Placeholder(text: 'Beni di consumo su MePa alla firma');
      case 22:
        return const _Placeholder(text: 'Attrezzature su MePa alla firma');
      case 23:
        return const _Placeholder(text: 'Servizi su MePa alla firma');
      case 31:
        return const _Placeholder(
          text: 'Beni di consumo fuori MePa alla firma',
        );
      case 32:
        return const _Placeholder(text: 'Pubblicazioni fuori MePa alla firma');
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 2: Procedure aperte ------------------------------------------
  Widget _procedureAperteContent(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return OpenProceduresAll();
      case 1:
        return OpenScholaship();
      case 21:
        return OpenMepaConsumerGoods();
      case 22:
        return OpenMepaEquipment();
      case 23:
        return OpenMepaServices();
      case 31:
        return OpenOutMepaConsumerGoods();
      case 32:
        return const _Placeholder(text: 'Pubblicazioni fuori MePa aperte');
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 3: Nuova procedura --------------------------------------------
  Widget _nuovaProceduraContent(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return SchoolarshipProcedure(rupId: rupId);
      case 1:
        return OnMepaProcedure(rupId: rupId);
      case 2:
        return OutMepaProcedure(rupId: rupId);
      default:
        return const SizedBox.shrink();
    }
  }
}

// Placeholder temporaneo, da sostituire man mano con i widget reali
// (form, tabelle, liste...) per ciascuna sezione.
class _Placeholder extends StatelessWidget {
  final String text;

  const _Placeholder({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: UnissLabel(text: text, textType: UnissTextType.bodyMedium),
    );
  }
}
