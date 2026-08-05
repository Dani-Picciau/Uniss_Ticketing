import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/ui_models/timeline_step_ui_model.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';
import 'package:timeline_tile/timeline_tile.dart';

class NodeItem extends StatelessWidget {
  // Parametri di configurazione temporanei per testare la UI
  final String title;
  final String role;
  final List<RequirementUiModel> requirements;

  // Parametri di stato della timeline
  final bool isFirst;
  final bool isLast;
  final bool isCompleted;
  final bool isActive;

  // Callback per le azioni dell'utente
  final Function(String requirementName, bool isChecked)? onRequirementToggled;
  final VoidCallback? onAdvanceStep;

  const NodeItem({
    super.key,
    required this.title,
    required this.role,
    required this.requirements,
    this.isFirst = false,
    this.isLast = false,
    this.isCompleted = false,
    this.isActive = false,
    this.onRequirementToggled,
    this.onAdvanceStep,
  });

  @override
  Widget build(BuildContext context) {
    // Definiamo i colori in base allo stato dello step
    final Color indicatorColor = isCompleted
        ? Colors.green
        : (isActive ? Colors.blue : Colors.grey.shade400);

    final Color lineColor = isCompleted ? Colors.green : Colors.grey.shade300;

    final bool canAdvance =
        requirements.isNotEmpty && requirements.every((r) => r.isSatisfied);

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.05, // Avvicina la linea al bordo sinistro (5% dello schermo)
      isFirst: isFirst,
      isLast: isLast,

      // Disegno del pallino
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

      // Stile delle linee di collegamento
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

            // Lista Requisiti (Generata dinamicamente) con checkbox
            ...requirements.map((req) {
              // Se lo step è completato, mostriamo un check verde fisso
              if (isCompleted) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_box,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: UnissLabel(
                          text: req.name,
                          textType: UnissTextType.labelMedium,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Se lo step è ATTIVO, mostriamo una Checkbox vera interattiva!
              if (isActive) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: req.isSatisfied,
                        onChanged: (bool? value) {
                          if (value != null && onRequirementToggled != null) {
                            onRequirementToggled!(req.name, value);
                          }
                        },
                      ),
                      Expanded(
                        child: UnissLabel(
                          text: req.name,
                          textType: UnissTextType.labelMedium,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Se è uno step futuro, mostriamo l'icona grigia disabilitata
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: UnissLabel(
                        text: req.name,
                        textType: UnissTextType.labelMedium,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),

            if (isActive) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: UnissLabel(
                  text: 'Conferma e vai allo step successivo',
                  textType: UnissTextType.labelMedium,
                  color: context.colors.white,
                ),
                onPressed: canAdvance ? onAdvanceStep : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
