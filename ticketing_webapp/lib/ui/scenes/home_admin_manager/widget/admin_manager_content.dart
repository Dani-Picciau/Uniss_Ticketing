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
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class AdminManagerContent extends StatelessWidget {
  final int tabIndex;
  final int sidebarIndex;

  const AdminManagerContent({
    super.key,
    required this.tabIndex,
    required this.sidebarIndex,
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
        return const _Placeholder(text: 'Tutte le procedure aperte ');
      case 1:
        return const _Placeholder(text: 'Borse di studio aperte');
      case 21:
        return const _Placeholder(text: 'Beni di consumo su MePa aperte');
      case 22:
        return const _Placeholder(text: 'Attrezzature su MePa aperte');
      case 31:
        return const _Placeholder(text: 'Beni di consumo fuori MePa aperte');
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
        return const _Placeholder(text: 'Nuova borsa di studio');
      case 1:
        return const _Placeholder(text: 'Nuova procedura su MePa');
      case 2:
        return const _Placeholder(text: 'Nuova procedura fuori MePa');
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
