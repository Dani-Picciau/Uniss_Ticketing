import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class UnissLabel extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final UnissTextType textType;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;

  final String? spanText;
  final UnissTextType? spanTextType;
  final Color? spanColor;

  final bool isSelectable; // Per rendere il testo selezionabile

  const UnissLabel({
    super.key,
    required this.text,
    required this.textType,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,

    // Parametri per la seconda parte di testo
    this.spanText,
    this.spanTextType,
    this.spanColor,

    this.isSelectable = false,
  });

  @override
  Widget build(BuildContext context) {
    // Calcoliamo lo stile base (per il testo principale)
    final baseStyle = getAppTextStyle(
      textType,
    )?.copyWith(color: color ?? context.colors.black);

    // 1. GESTIONE TESTO SINGOLO
    if (spanText == null) {
      if (isSelectable) {
        return SelectableText(
          text,
          textAlign: textAlign,
          style: baseStyle,
          maxLines: maxLines,
        );
      }
      return Text(
        text,
        textAlign: textAlign,
        style: baseStyle,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    // Se c'è la seconda parte, calcoliamo il suo stile
    final secondStyle = spanTextType != null
        ? getAppTextStyle(
            spanTextType!,
          )?.copyWith(color: spanColor ?? context.colors.black)
        : baseStyle?.copyWith(
            color: spanColor ?? context.colors.black,
          ); // Se non passi il tipo, eredita la grandezza

    if (isSelectable) {
      return SelectableText.rich(
        TextSpan(
          text: text,
          style: baseStyle,
          children: [TextSpan(text: spanText, style: secondStyle)],
        ),
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines,
      );
    }

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      text: TextSpan(
        text: text,
        style: baseStyle,
        children: [TextSpan(text: spanText, style: secondStyle)],
      ),
    );
  }
}
