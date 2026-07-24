import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class CommonDropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final void Function(String?) onChanged;
  final Color? labelColor;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final OutlineInputBorder? border;
  final String? errorText;

  const CommonDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.inputStyle,
    this.labelStyle,
    this.labelColor,
    this.border,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      style: inputStyle,
      decoration: InputDecoration(
        errorText: errorText,
        border: border,
        labelText: label,
        labelStyle: labelStyle?.copyWith(
          color: labelColor ?? context.colors.black,
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
