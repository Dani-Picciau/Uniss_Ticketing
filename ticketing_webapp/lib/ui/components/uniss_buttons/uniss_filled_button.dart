
import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class UnissFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;

  const UnissFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.loginButton,
          foregroundColor: context.colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: getAppTextStyle(
            UnissTextType.bodySmall,
          )?.copyWith(color: context.colors.white),
        ),
      ),
    );
  }
}
