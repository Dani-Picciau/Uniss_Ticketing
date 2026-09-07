import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class UnissIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? hoverColor;
  final Color? splashColor;
  final Duration hoverDuration;
  final double? iconWidth;
  final double? iconHeight;
  final EdgeInsetsGeometry? padding;
  final String? text;
  final String? tooltip;
  final UnissTextType? textType;
  final double? widgetWidth;
  final double iconTurns;

  const UnissIconButton({
    super.key,
    required this.onTap,
    required this.iconPath,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.hoverColor,
    this.splashColor,
    this.hoverDuration = const Duration(milliseconds: 250),
    this.iconWidth = 20,
    this.iconHeight = 20,
    this.padding,
    this.text,
    this.tooltip,
    this.textType,
    this.widgetWidth = 0,
    this.iconTurns = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        // Necessario per far funzionare InkWell
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ), // gestisce gli angoli arrotondati per lo sfondo vero e proprio
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: 1.5)
              : BorderSide.none,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            8,
          ), // gestisce gli angoli arrotondati per l'hover
          onTap: onTap,

          hoverColor: hoverColor,
          splashColor: splashColor,
          hoverDuration: hoverDuration,

          child: Padding(
            padding: padding ?? EdgeInsets.all(5),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: iconTurns,
                  duration: const Duration(milliseconds: 250),
                  child: SvgPicture.asset(
                    iconPath,
                    width: iconWidth,
                    height: iconHeight,
                    colorFilter: ColorFilter.mode(
                      iconColor ?? context.colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: widgetWidth),
                UnissLabel(
                  text: text ?? '',
                  textType: textType ?? UnissTextType.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        textStyle: unissTextTheme.labelSmall?.copyWith(
          color: context.colors.white, // colore testo
        ),
        decoration: BoxDecoration(
          color: context.colors.black,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: context.colors.blackAlpha015,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: const EdgeInsets.all(8),
        waitDuration: const Duration(milliseconds: 250),
        child: buttonContent,
      );
    }

    // Altrimenti restituiamo il bottone normale
    return buttonContent;
  }
}
