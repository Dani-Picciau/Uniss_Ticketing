import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class MultilineInputField extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final Color? labelColor;
  final int minLines;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const MultilineInputField({
    super.key,
    required this.label,
    this.labelStyle,
    this.inputStyle,
    this.labelColor,
    this.minLines = 3,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      maxLines: null, // Si espande all'infinito
      minLines: minLines, // Ma parte con un'altezza minima decorosa
      keyboardType: TextInputType.multiline,
      style: inputStyle,
      decoration: InputDecoration(
        errorText: errorText,
        labelText: label,
        alignLabelWithHint:
            true, // Mantiene la label in alto a sinistra, non al centro
        border: const OutlineInputBorder(),
        labelStyle: labelStyle?.copyWith(
          color: labelColor ?? context.colors.black,
        ),
      ),
    );
  }
}
