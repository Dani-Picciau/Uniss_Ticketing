import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class DateInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final Color? labelColor;

  const DateInputField({
    super.key,
    required this.controller,
    required this.label,
    this.labelStyle,
    this.inputStyle,
    this.labelColor,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  // Funzione che apre il calendario e aggiorna il testo
  Future<void> _selectDate(BuildContext context) async {
    // Apri il DatePicker nativo di Flutter
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Data di partenza
      firstDate: DateTime(1900), // Data minima selezionabile
      lastDate: DateTime(2100), // Data massima selezionabile
    );

    // Se l'utente ha selezionato una data (e non ha premuto "Annulla")
    if (pickedDate != null) {
      setState(() {
        // padLeft(2, '0') serbe per avere, ad esempio, "05" invece di "5"
        String day = pickedDate.day.toString().padLeft(2, '0');
        String month = pickedDate.month.toString().padLeft(2, '0');
        String year = pickedDate.year.toString();

        widget.controller.text = "$day/$month/$year";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: widget.inputStyle,
      readOnly: true, // Impedisce l'apertura della tastiera

      onTap: () => _selectDate(
        context,
      ), // Quando il campo viene toccato, si apre il calendario

      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: widget.labelStyle?.copyWith(
          color: widget.labelColor ?? context.colors.black,
        ),
        border: OutlineInputBorder(),
        prefixIcon: const Icon(Icons.calendar_today, size: 22),
      ),
    );
  }
}
