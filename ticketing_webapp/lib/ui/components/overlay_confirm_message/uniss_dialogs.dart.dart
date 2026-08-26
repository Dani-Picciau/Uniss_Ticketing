import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/uniss_buttons/uniss_filled_button.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class UnissDialogs {
  // Funzione statica da richiamare ovunque senza instanziare la classe
  static void showConfirmation(
    BuildContext context, {
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'Conferma',
    String cancelText = 'Annulla',
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Chiudi',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 350),

      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: context.colors.transparent,

            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.colors.warmPaper,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.blackAlpha015,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // MainAxisSize.min impedisce alla colonna di allungarsi all'infinito

                children: [
                  UnissLabel(text: message, textType: UnissTextType.bodyMedium),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UnissFilledButton(
                        backgroundColor: const Color.fromARGB(
                          255,
                          255,
                          159,
                          148,
                        ),
                        foregroundColor: context.colors.black,
                        textColor: const Color(0xFFC0392B),
                        text: confirmText,
                        onPressed: () {
                          Navigator.of(context).pop(); // Chiude il modale
                          onConfirm();
                        },
                      ),
                      SizedBox(width: 50),
                      UnissFilledButton(
                        text: cancelText,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },

      // Animazione in etrata e in uscita
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final slide =
            Tween<Offset>(
              begin: const Offset(0, -0.15),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }
}
