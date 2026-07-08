import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class SettingsButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const SettingsButton({
    super.key,
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

          hoverColor: context.colors.whiteAlpha03,
          splashColor: context.colors.blackAlpha01, // o usa primaryColor
          hoverDuration: const Duration(milliseconds: 250),

          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SvgPicture.asset(
              iconPath,
              width: 23,
              height: 23,
              colorFilter: ColorFilter.mode(
                context.colors.black, // O il tuo colore primario
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
