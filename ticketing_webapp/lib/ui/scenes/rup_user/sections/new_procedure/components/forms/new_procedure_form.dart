import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/autocomplete_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/date_input_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/drop_down_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/input_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/numeric_field.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/uniss_buttons/uniss_filled_button.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/models/ui_model/user_ui_model.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class SharedProcedureForm extends StatelessWidget {
  //Label per gli input e i bottoni
  final String formTitle;
  final String procedureNameLabel;
  final String procedureTypeLabel;
  final String procedureAmountLabel;

  final List<String> procedureTypes;
  final List<UserUiModel> professors;
  final List<UserUiModel> administrators;
  final bool isDesktop;

  // Valore corrente per la tendina Dropdown
  final String? selectedProcedureType;

  // Opzioni e valore per l'autocomplete "Borsa da rinnovare".
  // Il campo compare solo se isSchoolarship è vero E il tipo selezionato
  // è 'Rinnovo borsa' — il widget decide da solo quando mostrarlo,
  // guardando selectedProcedureType, senza bisogno di un flag booleano
  // aggiuntivo passato dal chiamante.
  final List<String> renewableScholarshipTitles;
  final ValueChanged<String>? onRenewalProcedureChanged;
  final String? renewalProcedureError;

  // Testi di errore calcolati da Formz
  final String? titleError;
  final String? procedureTypeError;
  final String? professorError;
  final String? administratorError;
  final String? amountError;
  final String? deadlineError;
  final String? durationError;
  final String? startDateError;
  final String? scholarshipHolderError;

  // Callback agganciate ai metodi Changed del Cubit
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String?> onProcedureTypeChanged;
  final ValueChanged<String> onProfessorChanged;
  final ValueChanged<String> onAdministratorChanged;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onDeadlineChanged;
  final ValueChanged<String>? onStartDateChanged;
  final ValueChanged<String>? onDurationChanged;
  final ValueChanged<String>? onScholarshipHolderChanged;

  // Azioni finali dei bottoni
  final VoidCallback?
  onSubmit; // Nullable per abilitare/disabilitare il bottone
  final VoidCallback onClear;

  final bool
  isMepa; // Serve per gestire la soglia dei 5000 su fuori Mepa --> true/false
  final bool isSchoolarship;
  final String durationValue;

  const SharedProcedureForm({
    super.key,
    required this.formTitle,
    required this.procedureNameLabel,
    required this.procedureTypeLabel,
    required this.procedureAmountLabel,

    required this.procedureTypes,
    required this.professors,
    required this.administrators,
    required this.isDesktop,

    this.selectedProcedureType,

    this.renewableScholarshipTitles = const [],
    this.onRenewalProcedureChanged,
    this.renewalProcedureError,

    this.titleError,
    this.procedureTypeError,
    this.professorError,
    this.administratorError,
    this.amountError,
    this.deadlineError,
    this.durationError,
    this.startDateError,
    this.scholarshipHolderError,

    required this.onTitleChanged,
    required this.onProcedureTypeChanged,
    required this.onProfessorChanged,
    required this.onAdministratorChanged,
    required this.onAmountChanged,
    required this.onDeadlineChanged,
    this.onStartDateChanged,
    required this.onDurationChanged,
    this.onScholarshipHolderChanged,
    required this.onSubmit,
    required this.onClear,

    required this.isMepa,
    required this.isSchoolarship,
    this.durationValue = '3',
  });
  //tot/current duration = mensile

  @override
  Widget build(BuildContext context) {
    final double parsedDuration =
        double.tryParse(durationValue.replaceAll(',', '.')) ?? 3.0;

    // Calcolato una volta, usato sia per decidere se mostrare il campo
    // sia (implicitamente) per la sua posizione nell'albero qui sotto.
    final bool showRenewalField =
        isSchoolarship && selectedProcedureType == 'Rinnovo borsa';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnissLabel(text: formTitle, textType: UnissTextType.headingMedium),
          const SizedBox(height: 24),

          CommonInputField(
            label: procedureNameLabel,
            labelStyle: unissTextTheme.bodySmall,
            inputStyle: unissTextTheme.bodySmall,
            labelColor: context.colors.gray,
            border: const OutlineInputBorder(),
            onChanged: onTitleChanged,
            errorText: titleError,
            isPassword: false,
          ),

          const SizedBox(height: 16),

          CommonDropdownField(
            border: const OutlineInputBorder(),
            labelColor: context.colors.gray,
            labelStyle: unissTextTheme.bodySmall,
            inputStyle: unissTextTheme.bodySmall,
            label: procedureTypeLabel,
            items: procedureTypes,
            value: selectedProcedureType,
            onChanged: onProcedureTypeChanged,
            errorText: procedureTypeError,
          ),

          if (showRenewalField) ...[
            const SizedBox(height: 16),
            CommonAutocompleteField(
              label: 'Borsa da rinnovare',
              labelStyle: unissTextTheme.bodySmall,
              inputStyle: unissTextTheme.bodySmall,
              border: const OutlineInputBorder(),
              options: renewableScholarshipTitles,
              onChanged: onRenewalProcedureChanged ?? (_) {},
              onSelected: onRenewalProcedureChanged ?? (_) {},
              errorText: renewalProcedureError,
            ),
          ],

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

          if (isSchoolarship && !showRenewalField) ...[
            CommonInputField(
              label: 'Inserire nome del borsista',
              labelStyle: unissTextTheme.bodySmall,
              inputStyle: unissTextTheme.bodySmall,
              labelColor: context.colors.gray,
              border: const OutlineInputBorder(),
              onChanged: onScholarshipHolderChanged,
              errorText: scholarshipHolderError,
              isPassword: false,
            ),
            const SizedBox(height: 16),
          ],

          if (isSchoolarship && onDurationChanged != null) ...[
            NumericField(
              label: 'Durata della borsa (in mesi)',
              suffixText: 'mesi',
              value: durationValue,
              min: showRenewalField ? 1 : 3,
              max: 12,
              labelStyle: unissTextTheme.bodySmall,
              inputStyle: unissTextTheme.bodySmall,
              labelColor: context.colors.gray,
              onChanged: onDurationChanged!,
              errorText: durationError,
            ),
            const SizedBox(height: 16),
          ],

          if (!showRenewalField) ...[
            NumericField(
              label: procedureAmountLabel,
              leftIcon: MediaConstants.euro,
              labelStyle: unissTextTheme.bodySmall,
              inputStyle: unissTextTheme.bodySmall,
              labelColor: context.colors.gray,
              onChanged: onAmountChanged,
              errorText: amountError,
              max: isMepa
                  ? null
                  : isSchoolarship
                  ? (2000 * parsedDuration)
                  : 5000,
            ),
            const SizedBox(height: 16),
          ],

          if (isSchoolarship &&
              !showRenewalField &&
              onStartDateChanged != null) ...[
            DateInputField(
              label: 'Inserire data di inzio',
              labelStyle: unissTextTheme.bodySmall,
              inputStyle: unissTextTheme.bodySmall,
              labelColor: context.colors.gray,
              onChanged: onStartDateChanged,
              errorText: startDateError,
            ),
            const SizedBox(height: 16),
          ],

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
                onPressed:
                    onSubmit, // Si spegne in automatico se passiamo null!
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
