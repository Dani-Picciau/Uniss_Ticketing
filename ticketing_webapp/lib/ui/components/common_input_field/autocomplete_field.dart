import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class CommonAutocompleteField extends StatelessWidget {
  final String label;
  final List<String> options;
  final void Function(String) onSelected;
  final OutlineInputBorder? border;
  final String? Function(String?)? validator;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final Color? labelColor;

  const CommonAutocompleteField({
    super.key,
    required this.label,
    required this.options,
    required this.onSelected,
    this.border,
    this.validator,
    this.labelStyle,
    this.inputStyle,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        // Filtra ignorando maiuscole/minuscole
        return options.where((String option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: onSelected,
      // Disegna il campo di testo mantenendo il tuo stile grafico
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              style: inputStyle,

              validator: validator,
              decoration: InputDecoration(
                labelText: label,
                border: border,
                labelStyle: labelStyle?.copyWith(
                  color: labelColor ?? context.colors.gray,
                ),
              ),
            );
          },
    );
  }
}
