import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/made_requests/all_requests/all_taking_charge_requests.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/made_requests/all_requests/all_waiting_requests.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/new_request/new_request.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/open_procedures/all_open_procedures/all_open_procedure.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/open_procedures/personal_open_procedures/personal_open_procedures.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/made_requests/personal_requests/personal_waiting_requests.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/made_requests/personal_requests/personal_taking_charge_requests.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class ProfessorUserContent extends StatelessWidget {
  final int tabIndex;
  final int sidebarIndex;

  const ProfessorUserContent({
    super.key,
    required this.tabIndex,
    required this.sidebarIndex,
  });

  @override
  Widget build(BuildContext context) {
    switch (tabIndex) {
      case 0:
        return _pendingRequests(sidebarIndex);
      case 1:
        return _madeRequests(sidebarIndex);
      case 2:
        return _openProcedures(sidebarIndex);
      case 3:
        return _newRequest(sidebarIndex);
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 0:  Alla firma (visibile solo al direttore) ----------------
  Widget _pendingRequests(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return const _Placeholder(text: 'In fase di sviluppo');
      case 1:
        return const _Placeholder(text: 'In fase di sviluppo');
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 1: Richieste in attesa ---------------------------------------
  Widget _madeRequests(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return PersonalWaitingRequests();
      case 1:
        return PersonalTakingChargeRequests();
      case 21:
        return AllWaitingRequests();
      case 22:
        return AllTakingChargeRequests();
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 2: Richieste prese in carico --------
  Widget _openProcedures(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return PersonalOpenProcedures();
      case 1:
        return AllOpenProcedures();
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 3: Nuova richiesta del docente ---------------------
  Widget _newRequest(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return NewProfessorRequest(); // Non ho bisogno di passare il "professorId" perché chi crea il ticket è sempre il proprietario, dunque prendo l'id direttamente dal token attraverso il backend.
      default:
        return const SizedBox.shrink();
    }
  }
}

// ====== Da eliminare una volta che tutte le funzioni saranno implementate ====
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
