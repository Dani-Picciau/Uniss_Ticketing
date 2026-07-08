import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/info_row/info_row.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class SettingsMenuItem extends StatefulWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const SettingsMenuItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  State<SettingsMenuItem> createState() => _SettingsMenuItemState();
}

class _SettingsMenuItemState extends State<SettingsMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      // Necessario per far funzionare InkWell
      color: context.colors.transparent,

      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onHover: (isHovering) => setState(() => _isHovered = isHovering),
        onTap: widget.onTap,
        hoverColor: Colors
            .transparent, // Lo "disattiviamo" per evitare conflitti con l'animazione del AnimatedContainer
        splashColor: context.colors.blackAlpha01,
        borderRadius: BorderRadius.circular(8),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: _isHovered
              ? EdgeInsets.only(left: 24, top: 12, bottom: 12)
              : EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? context.colors.blackAlpha01 : null,
            borderRadius: BorderRadius.circular(8),
          ),

          child: InfoRow(
            text: widget.title,
            iconPath: widget.iconPath,
            textType: UnissTextType.bodySmall,
            color: _isHovered ? context.colors.black : context.colors.gray,
          ),
        ),
      ),
    );
  }
}
