import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/core/network/api_client.dart';
import 'package:ticketing_webapp/core/storage/session_manager.dart';
import 'package:ticketing_webapp/features/repositories/new_procedure_api.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/utils/form_inputs.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/bloc/new_procedure_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/bloc/new_procedure_state.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/components/forms/new_procedure_form.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class OnMepaProcedure extends StatefulWidget {
  final String rupId;
  const OnMepaProcedure({super.key, required this.rupId});

  @override
  State<OnMepaProcedure> createState() => _OnMepaProcedureState();
}

class _OnMepaProcedureState extends State<OnMepaProcedure> {
  Key _formResetKey = UniqueKey();

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
        return NewProcedureCubit(
          repository: repository,
          isMepa: true,
          isSchoolarship: false,
        )..fetchInitialData();
      },
      child: FadeIn(
        offset: const Offset(-50, 0),
        duration: Duration(milliseconds: 500),
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
                    _formResetKey = UniqueKey();
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

                return SharedProcedureForm(
                  key: _formResetKey,
                  formTitle: 'Creazione di una nuova procedura su MePa',
                  procedureNameLabel: 'Titolo della procedura',
                  procedureTypeLabel: 'Tipo di procedura',
                  procedureTypes: const [
                    'Beni di consumo',
                    'Attrezzature',
                    'Servizi',
                  ],
                  professors: state.professors,
                  administrators: state.assignedAdministrator,
                  isDesktop: isDesktop,

                  // Mappatura della UI per il Dropdown
                  selectedProcedureType: switch (state.procedureType.value) {
                    "ORDINI_SU_MEPA_BENI_CONSUMO" => 'Beni di consumo',
                    "ORDINI_SU_MEPA_ATTREZZATURE" => 'Attrezzature',
                    "ORDINI_SERVIZI_SU_MEPA" => 'Servizi',
                    _ => null,
                  },
                  isMepa: true,
                  isSchoolarship: false,

                  // Mappatura Errori
                  titleError: state.title.displayError != null
                      ? 'Campo obbligatorio'
                      : null,
                  procedureTypeError: state.procedureType.displayError != null
                      ? 'Selezione obbligatoria'
                      : null,
                  professorError: state.selectedProfessorId.displayError != null
                      ? 'Selezione obbligatoria'
                      : null,
                  administratorError:
                      state.selectedAdministratorId.displayError != null
                      ? 'Selezione obbligatoria'
                      : null,
                  amountError:
                      state.amount.displayError == AmountInputError.empty
                      ? 'Importo obbligatorio'
                      : state.amount.displayError == AmountInputError.invalid
                      ? 'Numero non valido'
                      : state.amount.displayError ==
                            AmountInputError.zeroOrNegative
                      ? 'L\'importo deve essere > 0'
                      : null,
                  deadlineError: state.deadline.displayError != null
                      ? 'Data obbligatoria'
                      : null,
                  durationError: state.duration.displayError != null
                      ? 'Durata obbligatoria'
                      : null,

                  // Passaggio metodi Changed
                  onTitleChanged: (value) =>
                      context.read<NewProcedureCubit>().titleChanged(value),
                  onProcedureTypeChanged: (value) => context
                      .read<NewProcedureCubit>()
                      .procedureTypeChanged(value),
                  onProfessorChanged: (value) =>
                      context.read<NewProcedureCubit>().professorChanged(value),
                  onAdministratorChanged: (value) => context
                      .read<NewProcedureCubit>()
                      .administratorChanged(value),
                  onAmountChanged: (value) =>
                      context.read<NewProcedureCubit>().amountChanged(value),
                  onDeadlineChanged: (value) =>
                      context.read<NewProcedureCubit>().deadlineChanged(value),
                  onDurationChanged: (value) =>
                      context.read<NewProcedureCubit>().durationChanged(value),

                  // Azioni finali
                  onSubmit: state.isValid
                      ? () => context.read<NewProcedureCubit>().submitProcedura(
                          widget.rupId,
                        )
                      : null,
                  onClear: () {
                    context.read<NewProcedureCubit>().resetForm();
                    setState(() {
                      _formResetKey = UniqueKey();
                    });
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
