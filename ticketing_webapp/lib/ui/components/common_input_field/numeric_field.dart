import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class NumericField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final Color? labelColor;
  final String? leftIcon;
  final double min;
  final double? max;
  final double step; // Quanto aumenta/diminuisce ad ogni click sulle frecce
  final OutlineInputBorder? border;

  const NumericField({
    super.key,
    required this.controller,
    required this.label,
    this.labelStyle,
    this.inputStyle,
    this.labelColor,
    this.leftIcon,
    this.min = 0.0,
    this.max,
    this.step = 1.0, // Di default incrementa di 1
    this.border,
  });

  @override
  State<NumericField> createState() => _NumericFieldState();
}

class _NumericFieldState extends State<NumericField> {
  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isEmpty) {
      widget.controller.text = _formatOutput(widget.min);
    }
  }

  // Converte il testo (che potrebbe avere la virgola) in un double leggibile da Dart
  double _parseInput(String value) {
    if (value.isEmpty) return widget.min;
    // Sostituisce la virgola con il punto per non far crashare il tryParse
    String normalizedValue = value.replaceAll(',', '.');
    return double.tryParse(normalizedValue) ?? widget.min;
  }

  // Formatta il numero per mostrarlo all'utente (es. 5.0 diventa 5)
  String _formatOutput(double value) {
    String text = value.toString();
    // Se finisce con .0 (es. 5.0), lo puliamo mostrando solo "5"
    if (text.endsWith('.0')) {
      text = text.substring(0, text.length - 2);
    }
    // Riconvertiamo il punto in virgola per l'interfaccia utente
    return text.replaceAll('.', ',');
  }

  void _updateValue(double newValue) {
    final text = _formatOutput(newValue);
    widget.controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _increment() {
    double currentValue = _parseInput(widget.controller.text);

    if (widget.max == null || currentValue < widget.max!) {
      // Arrotonda per evitare problemi di precisione con i double (es. 1.0000000001)
      double newValue = currentValue + widget.step;
      if (widget.max != null && newValue > widget.max!) {
        newValue = widget.max!;
      }
      _updateValue(double.parse(newValue.toStringAsFixed(2)));
    }
  }

  void _decrement() {
    double currentValue = _parseInput(widget.controller.text);
    if (currentValue > widget.min) {
      double newValue = currentValue - widget.step;
      if (newValue < widget.min) {
        newValue = widget.min;
      }
      _updateValue(double.parse(newValue.toStringAsFixed(2)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: widget.inputStyle,
      // Abilita la tastiera con i decimali
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      // Permette numeri, punto e virgola
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: widget.labelStyle?.copyWith(
          color: widget.labelColor ?? context.colors.black,
        ),
        border: widget.border ?? const OutlineInputBorder(),
        prefixIcon: widget.leftIcon != null
            ? Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: SvgPicture.asset(
                  widget.leftIcon!,
                  width: 22,
                  height: 22,
                ),
              )
            : null,
        suffixIcon: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: _increment,
              child: const Icon(Icons.arrow_drop_up, size: 24),
            ),
            InkWell(
              onTap: _decrement,
              child: const Icon(Icons.arrow_drop_down, size: 24),
            ),
          ],
        ),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          String normalizedValue = value.replaceAll(',', '.');
          double? parsed = double.tryParse(normalizedValue);

          if (parsed != null && widget.max != null && parsed > widget.max!) {
            _updateValue(widget.max!);
          }
        }
      },
    );
  }
}
