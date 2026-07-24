import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/data/network/api_client.dart';
import 'package:ticketing_webapp/data/storage/session_manager.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/autocomplete_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/date_input_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/drop_down_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/input_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/numeric_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/utils/form_inputs.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/components/uniss_buttons/uniss_filled_button.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/bloc/new_procedure_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/bloc/new_procedure_state.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/repositories/new_procedure_api.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class OnMepaProcedure extends StatefulWidget {
  final String rupId;
  const OnMepaProcedure({super.key, required this.rupId});

  @override
  State<OnMepaProcedure> createState() => _OnMepaProcedureState();
}

class _OnMepaProcedureState extends State<OnMepaProcedure> {
  Key _professoreKey = UniqueKey();
  Key _amministratoreKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final sessionManager = SessionManager();
        final apiClient = ApiClient(sessionManager: sessionManager);
        final repository = ProcedureRepository(
          apiClient: apiClient,
          sessionManager: sessionManager,
        );
        return NewProcedureCubit(repository: repository)..fetchInitialData();
      },
      child: FadeIn(
        offset: const Offset(-50, 0),
        child: LayoutBuilder(
          builder: (context, outerConstraints) {
            final isDesktop = outerConstraints.maxWidth > 400;

            return BlocConsumer<NewProcedureCubit, NewProcedureState>(
              listener: (context, state) {
                if (state.status == ProcedureStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildMessangerSnackBar(
                      context,
                      text: 'Procedura creata con successo!',
                      iconPath: MediaConstants.success,
                      textColor: context.colors.white,
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.read<NewProcedureCubit>().resetForm();
                  setState(() {
                    _professoreKey = UniqueKey();
                    _amministratoreKey = UniqueKey();
                  });
                }
                if (state.status == ProcedureStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildMessangerSnackBar(
                      context,
                      text: state.errorMessage ?? 'Errore sconosciuto',
                      iconPath: MediaConstants.error,
                      textColor: context.colors.white,
                      backgroundColor: context.colors.errorMessage,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status == ProcedureStatus.loadingInitial ||
                    state.status == ProcedureStatus.submitting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UnissLabel(
                      text: 'Creazione di una nuova procedura su MePa',
                      textType: UnissTextType.headingMedium,
                    ),
                    const SizedBox(height: 24),

                    CommonInputField(
                      label: 'Nome della procedura',
                      labelStyle: unissTextTheme.bodySmall,
                      inputStyle: unissTextTheme.bodySmall,
                      labelColor: context.colors.gray,
                      border: const OutlineInputBorder(),
                      // --- FORMZ AGGANCI ---
                      onChanged: (value) =>
                          context.read<NewProcedureCubit>().titleChanged(value),
                      errorText: state.title.displayError != null
                          ? 'Campo obbligatorio'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    CommonDropdownField(
                      border: const OutlineInputBorder(),
                      labelColor: context.colors.gray,
                      labelStyle: unissTextTheme.bodySmall,
                      inputStyle: unissTextTheme.bodySmall,
                      label: 'Tipo di Procedura',
                      items: const ['Beni di consumo', 'Attrezzature'],
                      // Il Dropdown mantiene il proprio valore mostrato a schermo (perché non usiamo controller di testo qui)
                      value:
                          state.procedureType.value ==
                              "ORDINI_SU_MEPA_BENI_CONSUMO"
                          ? 'Beni di consumo'
                          : state.procedureType.value ==
                                "ORDINI_SU_MEPA_ATTREZZATURE"
                          ? 'Attrezzature'
                          : null,

                      onChanged: (value) => context
                          .read<NewProcedureCubit>()
                          .procedureTypeChanged(value),
                      errorText: state.procedureType.displayError != null
                          ? 'Selezione obbligatoria'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    CommonAutocompleteField(
                      key: _professoreKey,
                      label: 'Professore richiedente',
                      labelStyle: unissTextTheme.bodySmall,
                      inputStyle: unissTextTheme.bodySmall,
                      border: const OutlineInputBorder(),

                      options: state.professors
                          .map((p) => p.displayName)
                          .toList(),

                      // Cattura ogni singola lettera digitata a mano
                      onChanged: (String value) {
                        context.read<NewProcedureCubit>().professorChanged(
                          value,
                        );
                      },
                      // Cattura il click sul menu a tendina
                      onSelected: (String selection) {
                        context.read<NewProcedureCubit>().professorChanged(
                          selection,
                        );
                      },
                      errorText: state.selectedProfessorId.displayError != null
                          ? 'Selezione obbligatoria'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    CommonAutocompleteField(
                      key: _amministratoreKey,
                      label: 'Amministratore assegnato',
                      labelStyle: unissTextTheme.bodySmall,
                      inputStyle: unissTextTheme.bodySmall,
                      border: const OutlineInputBorder(),
                      options: state.assignedAdministrator
                          .map((p) => p.displayName)
                          .toList(),
                      onChanged: (String value) {
                        // Cattura ogni singola lettera digitata a mano
                        context.read<NewProcedureCubit>().administratorChanged(
                          value,
                        );
                      },
                      onSelected: (String selection) {
                        // Cattura il click sul menu a tendina
                        context.read<NewProcedureCubit>().administratorChanged(
                          selection,
                        );
                      },
                      errorText:
                          state.selectedAdministratorId.displayError != null
                          ? 'Selezione obbligatoria'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    NumericField(
                      label: 'Inserire un importo',
                      leftIcon: MediaConstants.euro,
                      labelStyle: unissTextTheme.bodySmall,
                      inputStyle: unissTextTheme.bodySmall,
                      labelColor: context.colors.gray,
                      // --- FORMZ AGGANCI ---
                      onChanged: (value) => context
                          .read<NewProcedureCubit>()
                          .amountChanged(value),
                      errorText:
                          state.amount.displayError == AmountInputError.empty
                          ? 'Importo obbligatorio'
                          : state.amount.displayError ==
                                AmountInputError.invalid
                          ? 'Numero non valido'
                          : state.amount.displayError ==
                                AmountInputError.zeroOrNegative
                          ? 'L\'importo deve essere > 0'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    DateInputField(
                      label: 'Inserire la deadline',
                      labelStyle: unissTextTheme.bodySmall,
                      inputStyle: unissTextTheme.bodySmall,
                      labelColor: context.colors.gray,

                      onChanged: (value) => context
                          .read<NewProcedureCubit>()
                          .deadlineChanged(value),
                      errorText: state.deadline.displayError != null
                          ? 'Data obbligatoria'
                          : null,
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
                          // Il bottone si abilita automaticamente solo se TUTTI i campi soddisfano le condizioni
                          onPressed: state.isValid
                              ? () => context
                                    .read<NewProcedureCubit>()
                                    .submitProcedura(widget.rupId)
                              : null,
                          width: isDesktop ? 200 : null,
                        ),
                        UnissFilledButton(
                          text: 'Svuota campi',
                          onPressed: () {
                            context.read<NewProcedureCubit>().resetForm();
                            setState(() {
                              _professoreKey = UniqueKey();
                              _amministratoreKey = UniqueKey();
                            });
                          },
                          width: isDesktop ? 200 : null,
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
