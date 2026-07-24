import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class NumericField extends StatefulWidget {
  final String label;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final Color? labelColor;
  final String? leftIcon;
  final double min;
  final double? max;
  final double step;
  final OutlineInputBorder? border;
  final ValueChanged<String>? onChanged; 
  final String? errorText;

  const NumericField({
    super.key,
    required this.label,
    this.labelStyle,
    this.inputStyle,
    this.labelColor,
    this.leftIcon,
    this.min = 0.0,
    this.max,
    this.step = 1.0,
    this.border,
    this.onChanged,
    this.errorText,
  });

  @override
  State<NumericField> createState() => _NumericFieldState();
}

class _NumericFieldState extends State<NumericField> {
  // Il controller diventa privato e interno al widget
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatOutput(widget.min));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _parseInput(String value) {
    if (value.isEmpty) return widget.min;
    String normalizedValue = value.replaceAll(',', '.');
    return double.tryParse(normalizedValue) ?? widget.min;
  }

  String _formatOutput(double value) {
    String text = value.toString();
    if (text.endsWith('.0')) {
      text = text.substring(0, text.length - 2);
    }
    return text.replaceAll('.', ',');
  }

  void _updateValue(double newValue) {
    final text = _formatOutput(newValue);
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );

    // Avvisa il Cubit che il valore è cambiato tramite i bottoncini
    widget.onChanged?.call(text);
  }

  void _increment() {
    double currentValue = _parseInput(_controller.text);
    if (widget.max == null || currentValue < widget.max!) {
      double newValue = currentValue + widget.step;
      if (widget.max != null && newValue > widget.max!) newValue = widget.max!;
      _updateValue(double.parse(newValue.toStringAsFixed(2)));
    }
  }

  void _decrement() {
    double currentValue = _parseInput(_controller.text);
    if (currentValue > widget.min) {
      double newValue = currentValue - widget.step;
      if (newValue < widget.min) newValue = widget.min;
      _updateValue(double.parse(newValue.toStringAsFixed(2)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      style: widget.inputStyle,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      decoration: InputDecoration(
        errorText: widget.errorText,
        labelText: widget.label,
        labelStyle: widget.labelStyle?.copyWith(
          color: widget.labelColor ?? context.colors.black,
        ),
        border: widget.border ?? const OutlineInputBorder(),
        prefixIcon: widget.leftIcon != null
            ? Padding(
                padding: const EdgeInsetsGeometry.all(8),
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
        // 3. Logica interna mantenuta
        if (value.isNotEmpty) {
          String normalizedValue = value.replaceAll(',', '.');
          double? parsed = double.tryParse(normalizedValue);

          if (parsed != null && widget.max != null && parsed > widget.max!) {
            _updateValue(widget.max!);
            return; // Il metodo _updateValue chiamerà già widget.onChanged, quindi ci fermiamo
          }
        }

        // Se non ha superato il max, avvisiamo normalmente il Cubit del nuovo testo digitato
        widget.onChanged?.call(value);
      },
    );
  }
}
