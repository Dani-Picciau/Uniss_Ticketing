import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  // Larghezza schermo sotto la quale il badge si "comprime" mostrando solo il pallino.
  static const double _compactBreakpoint = 1000;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // fallback/default per la maggior parte degli stati
    Color backgroundColor = Colors.blue.shade100;
    Color borderColor = Colors.blue.shade300;
    Color textColor = Colors.blue.shade800;

    // Modifico il colore del badge solo se la procedura è completa
    if (status == 'COMPLETATA') {
      backgroundColor = Colors.green.shade100;
      borderColor = Colors.green.shade300;
      textColor = Colors.green.shade800;
    }

    final isCompact = MediaQuery.sizeOf(context).width < _compactBreakpoint;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: textColor),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: isCompact ? 0 : 1,
              child: isCompact
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: UnissLabel(
                        text: status,
                        textType: UnissTextType.bodySmall,
                        color: textColor,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
