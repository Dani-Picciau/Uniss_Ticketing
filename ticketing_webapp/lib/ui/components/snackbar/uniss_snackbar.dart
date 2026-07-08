// ALTERNATIVA senza classe: nessun contenitore, solo una funzione libera
// nel file. Stesso identico comportamento della versione con
// "abstract final class MessangerSnackBar { static SnackBar build(...) }",
// solo meno cerimonia. La differenza è puramente organizzativa: qui il
// nome vive da solo nel file, non "raggruppato" sotto un nome di classe.

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

SnackBar buildMessangerSnackBar(
  BuildContext context, {
  required String text,
  required String iconPath,
  required Color textColor,
  required Color backgroundColor,
}) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.all(16),
    elevation: 0,
    // transparent è sempre trasparente in entrambi i temi: costante fissa.
    backgroundColor: Colors.transparent,
    content: Align(
      alignment: Alignment.bottomCenter,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor, // arriva già risolto da chi lo chiama
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UnissLabel(
              text: text,
              color: textColor,
              textType: UnissTextType.bodySmall,
            ),
            const SizedBox(width: 20),

            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                // white è un pigmento fisso, non cambia col tema.
                color: Colors.white,
              ),

              child: SvgPicture.asset(iconPath, width: 22, height: 22),
            ),
          ],
        ),
      ),
    ),
  );
}
