import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class InfoRow extends StatelessWidget {
  final String text;
  final String iconPath;
  final UnissTextType textType;
  final Color? color;
  final double iconTurns;

  const InfoRow({
    super.key,
    required this.text,
    required this.iconPath,
    required this.textType,
    this.color,
    this.iconTurns = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? context.colors.gray;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedRotation(
          turns: iconTurns,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: SvgPicture.asset(
            iconPath,
            width: 22,
            height: 22,
            // Applichiamo il colore che ci arriva dal genitore
            colorFilter: ColorFilter.mode(resolvedColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: UnissLabel(text: text, textType: textType, color: color),
        ),
      ],
    );
  }
}
