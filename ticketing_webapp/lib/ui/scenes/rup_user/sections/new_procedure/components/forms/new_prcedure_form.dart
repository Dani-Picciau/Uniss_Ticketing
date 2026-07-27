import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/autocomplete_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/date_input_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/drop_down_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/input_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/numeric_field.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/uniss_buttons/uniss_filled_button.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/data/models/ui_model/user_ui_model.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class SharedProcedureForm extends StatelessWidget {
  final String formTitle;
  final List<String> procedureTypes;
  final List<UserUiModel> professors;
  final List<UserUiModel> administrators;
  final bool isDesktop;

  // Valore corrente per la tendina Dropdown
  final String? selectedProcedureType;
  
  // Testi di errore calcolati da Formz
  final String? titleError;
  final String? procedureTypeError;
  final String? professorError;
  final String? administratorError;
  final String? amountError;
  final String? deadlineError;

  // Callback agganciate ai metodi Changed del Cubit
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String?> onProcedureTypeChanged;
  final ValueChanged<String> onProfessorChanged;
  final ValueChanged<String> onAdministratorChanged;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onDeadlineChanged;
  
  // Azioni finali dei bottoni
  final VoidCallback? onSubmit; // Nullable per abilitare/disabilitare il bottone
  final VoidCallback onClear;

  const SharedProcedureForm({
    super.key,
    required this.formTitle,
    required this.procedureTypes,
    required this.professors,
    required this.administrators,
    required this.isDesktop,
    this.selectedProcedureType,
    this.titleError,
    this.procedureTypeError,
    this.professorError,
    this.administratorError,
    this.amountError,
    this.deadlineError,
    required this.onTitleChanged,
    required this.onProcedureTypeChanged,
    required this.onProfessorChanged,
    required this.onAdministratorChanged,
    required this.onAmountChanged,
    required this.onDeadlineChanged,
    required this.onSubmit,
    required this.onClear,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UnissLabel(
          text: formTitle,
          textType: UnissTextType.headingMedium,
        ),
        const SizedBox(height: 24),

        CommonInputField(
          label: 'Nome della procedura',
          labelStyle: unissTextTheme.bodySmall,
          inputStyle: unissTextTheme.bodySmall,
          labelColor: context.colors.gray,
          border: const OutlineInputBorder(),
          onChanged: onTitleChanged,
          errorText: titleError,
        ),

        const SizedBox(height: 16),

        CommonDropdownField(
          border: const OutlineInputBorder(),
          labelColor: context.colors.gray,
          labelStyle: unissTextTheme.bodySmall,
          inputStyle: unissTextTheme.bodySmall,
          label: 'Tipo di Procedura',
          items: procedureTypes,
          value: selectedProcedureType,
          onChanged: onProcedureTypeChanged,
          errorText: procedureTypeError,
        ),

        const SizedBox(height: 16),

        CommonAutocompleteField(
          label: 'Professore richiedente',
          labelStyle: unissTextTheme.bodySmall,
          inputStyle: unissTextTheme.bodySmall,
          border: const OutlineInputBorder(),
          options: professors.map((p) => p.displayName).toList(),
          onChanged: onProfessorChanged,
          onSelected: onProfessorChanged,
          errorText: professorError,
        ),

        const SizedBox(height: 16),

        CommonAutocompleteField(
          label: 'Amministratore assegnato',
          labelStyle: unissTextTheme.bodySmall,
          inputStyle: unissTextTheme.bodySmall,
          border: const OutlineInputBorder(),
          options: administrators.map((p) => p.displayName).toList(),
          onChanged: onAdministratorChanged,
          onSelected: onAdministratorChanged,
          errorText: administratorError,
        ),

        const SizedBox(height: 16),

        NumericField(
          label: 'Inserire un importo',
          leftIcon: MediaConstants.euro,
          labelStyle: unissTextTheme.bodySmall,
          inputStyle: unissTextTheme.bodySmall,
          labelColor: context.colors.gray,
          onChanged: onAmountChanged,
          errorText: amountError,
        ),

        const SizedBox(height: 16),

        DateInputField(
          label: 'Inserire la deadline',
          labelStyle: unissTextTheme.bodySmall,
          inputStyle: unissTextTheme.bodySmall,
          labelColor: context.colors.gray,
          onChanged: onDeadlineChanged,
          errorText: deadlineError,
        ),

        const SizedBox(height: 16),

        Flex(
          direction: isDesktop ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: isDesktop
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: [
            UnissFilledButton(
              text: 'Crea procedura',
              onPressed: onSubmit, // Si spegne in automatico se passiamo null!
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
    );
  }
}