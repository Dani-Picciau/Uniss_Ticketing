import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/new_request/new_request.dart';
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
        return _awaitingSignature(sidebarIndex);
      case 1:
        return _pendingRequests(sidebarIndex);
      case 2:
        return _openProcedures(sidebarIndex);
      case 3:
        return _newRequest(sidebarIndex);
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 0: Richieste personali -----------------------------------
  Widget _awaitingSignature(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return const _Placeholder(text: 'Prova');
      case 1:
        return const _Placeholder(text: 'Prova');
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 1: Nuova richiesta -----------------------------------------
  Widget _pendingRequests(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return const _Placeholder(text: 'Prova');
      case 1:
        return const _Placeholder(text: 'Prova');
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 2: Tutte le richieste dei docenti (visibili solo al direttore) --------
  Widget _openProcedures(int sidebarIndex) {
    switch (sidebarIndex) {
      case 0:
        return const _Placeholder(text: 'Prova');
      case 1:
        return const _Placeholder(text: 'Prova');
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Tab 3: Alla firma (visibile solo al direttore) ---------------------
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
