import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class UnissLabel extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final UnissTextType textType;
  final Color? color;

  const UnissLabel({
    super.key,
    required this.text,
    required this.textType,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: getAppTextStyle(
        textType,
      )?.copyWith(color: color ?? context.colors.black),
    );
  }
}
