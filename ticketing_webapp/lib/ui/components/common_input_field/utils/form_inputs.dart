import 'package:formz/formz.dart';

// Modello per i campi di testo normali come: Titolo, Data, Dropdown, Autocomplete)
enum TextInputError { empty }

class TextInput extends FormzInput<String, TextInputError> {
  const TextInput.pure() : super.pure('');
  const TextInput.dirty([super.value = '']) : super.dirty();

  @override
  TextInputError? validator(String value) {
    // Se la stringa è vuota, restituisce l'errore 'empty'
    return value.trim().isEmpty ? TextInputError.empty : null;
  }
}

// Modello specifico per i numeri (Importo)
enum AmountInputError { empty, invalid, zeroOrNegative }

class AmountInput extends FormzInput<String, AmountInputError> {
  const AmountInput.pure() : super.pure('');
  const AmountInput.dirty([super.value = '']) : super.dirty();

  @override
  AmountInputError? validator(String value) {
    if (value.trim().isEmpty) return AmountInputError.empty;
    // Sostituisce l'eventuale virgola con il punto per il parsing
    final amount = double.tryParse(value.replaceAll(',', '.'));
    if (amount == null) return AmountInputError.invalid;
    if (amount <= 0) return AmountInputError.zeroOrNegative;
    return null;
  }
}
