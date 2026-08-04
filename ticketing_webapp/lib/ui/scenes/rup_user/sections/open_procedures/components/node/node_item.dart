import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';
import 'package:timeline_tile/timeline_tile.dart';

class NodeItem extends StatelessWidget {
  // Parametri di configurazione temporanei per testare la UI
  final String title;
  final String role;
  final List<String> requirements;

  // Parametri di stato della timeline
  final bool isFirst;
  final bool isLast;
  final bool isCompleted;
  final bool isActive;

  const NodeItem({
    super.key,
    required this.title,
    required this.role,
    required this.requirements,
    this.isFirst = false,
    this.isLast = false,
    this.isCompleted = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    // Definiamo i colori in base allo stato dello step
    final Color indicatorColor = isCompleted
        ? Colors.green
        : (isActive ? Colors.blue : Colors.grey.shade400);

    final Color lineColor = isCompleted ? Colors.green : Colors.grey.shade300;

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.05, // Avvicina la linea al bordo sinistro (5% dello schermo)
      isFirst: isFirst,
      isLast: isLast,

      // 2. Disegniamo il pallino
      indicatorStyle: IndicatorStyle(
        width: 30,
        height: 30,
        color: indicatorColor,
        // Se è completato mettiamo una spunta bianca, altrimenti lasciamo vuoto o mettiamo un pallino interno
        iconStyle: isCompleted
            ? IconStyle(
                iconData: Icons.check,
                color: Colors.white,
                fontSize: 20,
              )
            : (isActive
                  ? IconStyle(
                      iconData: Icons.circle,
                      color: Colors.white,
                      fontSize: 12,
                    )
                  : null),
      ),

      // 3. Stile delle linee di collegamento
      beforeLineStyle: LineStyle(color: lineColor, thickness: 3),
      afterLineStyle: LineStyle(
        color: isActive ? Colors.grey.shade300 : lineColor,
        thickness: 3,
      ),

      endChild: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: 32.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titolo
            UnissLabel(
              text: title,
              textType: UnissTextType.bodyLarge,
              color: (isCompleted || isActive)
                  ? Colors.black
                  : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),

            // Badge Ruolo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: UnissLabel(text: role, textType: UnissTextType.bodySmall),
            ),
            const SizedBox(height: 16),

            // Lista Requisiti (Generata dinamicamente)
            ...requirements.map(
              (req) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 20,
                      color: (isCompleted || isActive)
                          ? Colors.black54
                          : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: UnissLabel(
                        text: req,
                        textType: UnissTextType.labelMedium,
                        color: (isCompleted || isActive)
                            ? Colors.black87
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
