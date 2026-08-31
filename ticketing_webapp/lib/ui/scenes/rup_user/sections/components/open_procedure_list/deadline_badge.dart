import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class DeadlineBadge extends StatelessWidget {
  final DateTime? deadline;
  final int warningDays; //utile per scegliere il range di avviso
  static const double _compactBreakpoint = 1000;

  const DeadlineBadge({
    super.key,
    required this.deadline,
    this.warningDays = 7,
  });

  @override
  Widget build(BuildContext context) {
    // Se non c'è una scadenza, possiamo decidere di non mostrare nulla
    // oppure mostrare un badge grigio. Qui optiamo per nasconderlo.
    if (deadline == null) {
      return const SizedBox.shrink();
    }

    final now = DateTime.now();
    // Calcoliamo la differenza in giorni azzerando ore/minuti per massima precisione
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDate = DateTime(
      deadline!.year,
      deadline!.month,
      deadline!.day,
    );
    final difference = deadlineDate.difference(today).inDays;

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    String textPrefix;

    // Logica dei colori in base alla vicinanza
    if (difference < 0) {
      // SCADUTA (Rosso)
      backgroundColor = const Color(0xFFFDECEA);
      borderColor = const Color(0xFFC0392B);
      textColor = const Color(0xFFC0392B);
      textPrefix = 'Scaduta: ';
    } else if (difference <= warningDays) {
      // IN SCADENZA (Meno di 7 giorni - Arancione)
      backgroundColor = const Color(0xFFFFF3E0);
      borderColor = const Color(0xFFD35400);
      textColor = const Color(0xFFD35400);
      textPrefix = difference == 0
          ? 'Scade oggi: '
          : 'Scade tra $difference gg: ';
    } else {
      // NEI TEMPI (Più di 7 giorni - Verde)
      backgroundColor = Colors.green.shade100;
      borderColor = Colors.green.shade300;
      textColor = Colors.green.shade800;
      textPrefix = 'Scadenza: ';
    }

    // Parse manuale della data nel formato DD/MM/YYYY (senza bisogno di pacchetti extra)
    final day = deadline!.day.toString().padLeft(2, '0');
    final month = deadline!.month.toString().padLeft(2, '0');
    final year = deadline!.year;
    final dateString = '$day/$month/$year';

    final isCompact = MediaQuery.sizeOf(context).width < _compactBreakpoint;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: isCompact ? 0 : 1,
              child: isCompact
                  ? const SizedBox.shrink()
                  : UnissLabel(
                      text: textPrefix,
                      textType: UnissTextType.bodySmall,
                      color: textColor,
                    ),
            ),
          ),
          UnissLabel(
            text: dateString,
            textType: UnissTextType.bodySmall,
            color: textColor,
          ),
        ],
      ),
    );
  }
}
