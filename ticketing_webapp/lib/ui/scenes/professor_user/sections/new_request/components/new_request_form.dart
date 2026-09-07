import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/input_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/multiline_input_field.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/uniss_buttons/uniss_filled_button.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class NewRequestForm extends StatelessWidget {
  final String formTitle;
  final String requestNameLabel;
  final String requestBodyLabel;

  // Testi di errore calcolati da Formz
  final String? titleError;
  final String? bodyError;

  // Callback agganciate ai metodi Changed del Cubit
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onBodyChanged;

  // Azioni finali dei bottoni
  final VoidCallback?
  onSubmit; // Nullable per abilitare/disabilitare il bottone
  final VoidCallback onClear;

  final bool isDesktop;

  const NewRequestForm({
    super.key,
    required this.formTitle,
    required this.requestNameLabel,
    required this.requestBodyLabel,

    required this.onTitleChanged,
    required this.onBodyChanged,
    required this.onSubmit,
    required this.onClear,

    this.titleError,
    this.bodyError,

    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnissLabel(text: formTitle, textType: UnissTextType.headingMedium),

          const SizedBox(height: 24),

          CommonInputField(
            label: requestNameLabel,
            labelStyle: unissTextTheme.bodySmall,
            inputStyle: unissTextTheme.bodySmall,
            labelColor: context.colors.gray,
            border: const OutlineInputBorder(),
            onChanged: onTitleChanged,
            errorText: titleError,
            isPassword: false,
          ),

          const SizedBox(height: 16),

          MultilineInputField(
            label: requestBodyLabel,
            labelStyle: unissTextTheme.bodySmall,
            inputStyle: unissTextTheme.bodySmall,
            labelColor: context.colors.gray,
            onChanged: onBodyChanged,
            errorText: bodyError,
          ),

          const SizedBox(height: 16),

          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: isDesktop
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              UnissFilledButton(
                text: 'Invia richiesta',
                onPressed: onSubmit,
                width: isDesktop ? 200 : null,
              ),
              UnissFilledButton(
                text: 'Svuota campi',
                onPressed: onClear,
                width: isDesktop ? 200 : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
