import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/animations/switchable_icon.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class ThemeToggleMenuItem extends StatefulWidget {
  final String lightIconPath;
  final String darkIconPath;
  final bool isDarkMode;
  final VoidCallback onTap;

  const ThemeToggleMenuItem({
    super.key,
    required this.lightIconPath,
    required this.darkIconPath,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  State<ThemeToggleMenuItem> createState() => _ThemeToggleMenuItemState();
}

class _ThemeToggleMenuItemState extends State<ThemeToggleMenuItem> {
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
        hoverColor: context
            .colors
            .transparent, // Lo "disattiviamo" per evitare conflitti con l'animazione del AnimatedContainer
        splashColor: context.colors.blackAlpha01,
        borderRadius: BorderRadius.circular(8),

        child: AnimatedContainer(
          width: double.infinity,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: _isHovered
              ? const EdgeInsets.only(left: 24, top: 12, bottom: 12)
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? context.colors.blackAlpha01 : null,
            borderRadius: BorderRadius.circular(8),
          ),

          child: Row(
            children: [
              SwitchableIcon(
                firstIconPath: widget.darkIconPath,
                secondIconPath: widget.lightIconPath,
                showFirst: !widget.isDarkMode,
                color: _isHovered ? context.colors.black : context.colors.gray,
              ),
              const SizedBox(width: 8),
              UnissLabel(
                text: widget.isDarkMode ? 'light mode' : 'dark mode',
                textType: UnissTextType.bodySmall,
                color: _isHovered ? context.colors.black : context.colors.gray,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
