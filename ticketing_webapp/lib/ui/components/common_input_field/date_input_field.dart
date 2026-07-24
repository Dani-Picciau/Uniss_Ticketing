import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class DateInputField extends StatefulWidget {
  final String label;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final Color? labelColor;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  // Il controller è stato rimosso dai parametri richiesti!
  const DateInputField({
    super.key,
    required this.label,
    this.labelStyle,
    this.inputStyle,
    this.labelColor,
    this.onChanged,
    this.errorText,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  // Creiamo un controller privato ad uso esclusivo di questo widget
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String day = pickedDate.day.toString().padLeft(2, '0');
      String month = pickedDate.month.toString().padLeft(2, '0');
      String year = pickedDate.year.toString();

      final formattedDate = "$day/$month/$year";

      // 2. Aggiorniamo il controller interno per mostrare il testo all'utente
      _controller.text = formattedDate;

      // 3. FONDAMENTALE: Avvisiamo il Cubit che il valore è cambiato!
      widget.onChanged?.call(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // Non usiamo più widget.onChanged qui, perché per i campi readOnly
      // l'evento onChanged nativo non scatta quando cambiamo il testo via codice.
      // Lo stiamo già chiamando manualmente dentro _selectDate!
      controller: _controller,
      style: widget.inputStyle,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        errorText: widget.errorText, 
        labelText: widget.label,
        labelStyle: widget.labelStyle?.copyWith(
          color: widget.labelColor ?? context.colors.black,
        ),
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.calendar_today, size: 22),
      ),
    );
  }
}
