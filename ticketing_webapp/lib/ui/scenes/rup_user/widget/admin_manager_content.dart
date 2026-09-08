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
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/all/all_deadlines.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/on_mepa/consumer_goods/on_mepa_consumer_goods_deadline.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/on_mepa/equipment/on_mepa_equipment_deadline.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/on_mepa/services/on_mepa_services_deadline.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/outside_mepa/consumer_goods/consumer_goods_deadline_out_mepa.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/outside_mepa/publication/publication_deadline_out_mepa.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/scholarship/new_scholarship_deadline.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/scholarship/renewal_scholarship_deadline.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/new_on_mepa.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/new_outside_mepa.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/new_scholarship.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/all/open_procedures_all.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/on_mepa/consumer_goods/open_mepa_consumer_goods.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/on_mepa/equipment/open_mepa_equipment.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/on_mepa/services/open_mepa_services.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/outside_mepa/consumer_goods/open_out_mepa_consumer_goods.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/outside_mepa/publication/open_out_mepa_publications.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/scholaship/open_new_scholaship.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/scholaship/open_renweal_scholaship.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/requests/incoming_requests.dart';
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
        return _professorsRequests(sidebarIndex);
      case 2:
        return _allaFirmaContent(sidebarIndex);
      case 3:
        return _procedureAperteContent(sidebarIndex);
      case 4:
        return _nuovaProceduraContent(sidebarIndex);
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 0: Scadenze -------------------------------------------------
  Widget _scadenzeContent(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return AllDeadlines();
      case 11:
        return NewScholarshipDeadline();
      case 12:
        return RenewalScholarshipDeadline();
      case 21:
        return OnMepaConsumerGoodsDeadline();
      case 22:
        return OnMepaEquipmentDeadline();
      case 23:
        return OnMepaServicesDeadline();
      case 31:
        return ConsumerGoodsDeadlineOutMepa();
      case 32:
        return PublicationDeadlines();
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 1: Richieste docenti -----------------------------------------
  Widget _professorsRequests(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return IncomingRequests();
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 2: Alla firma ------------------------------------------------
  Widget _allaFirmaContent(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return const _Placeholder(text: 'Tutti i documenti alla firma');
      case 11:
        return const _Placeholder(text: 'Borse di studio alla firma');
      case 12:
        return Placeholder(child: Text('rinnovo borse'));
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

  // --- Tab 3: Procedure aperte ------------------------------------------
  Widget _procedureAperteContent(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return OpenProceduresAll();
      case 11:
        return OpenNewScholaship();
      case 12:
        return OpenRenewalScholaship();
      case 21:
        return OpenMepaConsumerGoods();
      case 22:
        return OpenMepaEquipment();
      case 23:
        return OpenMepaServices();
      case 31:
        return OpenOutMepaConsumerGoods();
      case 32:
        return OpenOutMepaPublications();
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 4: Nuova procedura --------------------------------------------
  // In ongi procedura passo l'id del RUP per averne il controllo anche se non vengono create dal RUP stesso
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

//====== Da eliminare quando completo la sezione alla firma =======
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
