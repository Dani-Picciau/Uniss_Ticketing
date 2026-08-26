import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class UnissFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? textColor;
  final double? width;

  const UnissFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.textColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Color(0xFF1C1C1E),
          foregroundColor: foregroundColor ?? context.colors.white,
          padding: (width == null)
              ? const EdgeInsets.symmetric(vertical: 18, horizontal: 24)
              : const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: getAppTextStyle(
            UnissTextType.bodySmall,
          )?.copyWith(color: textColor ?? context.colors.white),
        ),
      ),
    );
  }
}
