import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/info_row/info_row.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class OpenCloseNotes extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const OpenCloseNotes({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        // Necessario per far funzionare InkWell
        color: context.colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,

          hoverColor: context.colors.blackAlpha01,
          splashColor: context.colors.blackAlpha015,
          hoverDuration: const Duration(milliseconds: 250),

          child: Padding(
            padding: EdgeInsetsGeometry.all(5),
            child: InfoRow(
              text: title,
              iconPath: iconPath,
              textType: UnissTextType.bodyMedium,
              color: context.colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
