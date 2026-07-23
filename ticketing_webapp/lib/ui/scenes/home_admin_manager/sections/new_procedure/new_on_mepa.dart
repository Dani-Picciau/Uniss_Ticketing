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
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/components/uniss_buttons/uniss_filled_button.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/bloc/new_procedure_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/bloc/new_procedure_state.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/request/procedure_request.dart';
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
  final _formKey = GlobalKey<FormState>();

  String? procedureType;
  late final TextEditingController procedureName;
  late final TextEditingController requestingProfessor;
  late final TextEditingController assignedAdministrator;
  late final TextEditingController procedureAmount;
  late final TextEditingController finalDeadline;

  @override
  void initState() {
    super.initState();
    // Inizializzati quando il widget viene creato
    procedureName = TextEditingController();
    requestingProfessor = TextEditingController();
    assignedAdministrator = TextEditingController();
    procedureAmount = TextEditingController();
    finalDeadline = TextEditingController();
  }

  @override
  void dispose() {
    // Vengono distrutti per liberare memoria
    procedureName.dispose();
    requestingProfessor.dispose();
    procedureAmount.dispose();
    super.dispose();
  }

  Key _professoreKey = UniqueKey();
  Key _amministratoreKey = UniqueKey();
  void _clearFields() {
    setState(() {
      // Svuota tutti i controller di testo
      procedureName.clear();
      requestingProfessor.clear();
      assignedAdministrator.clear();
      procedureAmount.clear();
      procedureType = null;
      finalDeadline.clear();

      // Ogni volta che richiamo "_clearFields" assegno agli autocomplete delle chiavi nuove per resettarsi
      _professoreKey = UniqueKey();
      _amministratoreKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final sessionManager = SessionManager();
        final apiClient = ApiClient(sessionManager: sessionManager);

        // 2. Creiamo fisicamente il nostro nuovo repository
        final repository = ProcedureRepository(
          apiClient: apiClient,
          sessionManager: sessionManager,
        );

        // 3. Lo passiamo al Cubit e lanciamo la chiamata
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
                  // Opzionale: Svuota i campi dopo il salvataggio
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
                    state.status == ProcedureStatus.error ||
                    state.status == ProcedureStatus.submitting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UnissLabel(
                        text: 'Creazione di una nuova procedura su MePa',
                        textType: UnissTextType.headingMedium,
                      ),

                      SizedBox(height: 24),

                      CommonInputField(
                        controller: procedureName,
                        label: 'Nome della procedura',
                        labelStyle: unissTextTheme.bodySmall,
                        inputStyle: unissTextTheme.bodySmall,
                        labelColor: context.colors.gray,
                        border: OutlineInputBorder(),
                      ),

                      SizedBox(height: 16),

                      CommonDropdownField(
                        labelColor: context.colors.gray,
                        labelStyle: unissTextTheme.bodySmall,
                        inputStyle: unissTextTheme.bodySmall,
                        label: 'Tipo di Procedura',
                        items: const ['Beni di consumo', 'Attrezzature'],
                        value: procedureType,
                        border: const OutlineInputBorder(),
                        onChanged: (newValue) {
                          setState(() {
                            procedureType = newValue;
                          });
                        },
                        validator: (valore) {
                          if (valore == null || valore.isEmpty) {
                            return 'Seleziona una categoria obbligatoria';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16),

                      CommonAutocompleteField(
                        key: _professoreKey,
                        label: 'Professore richiedente',
                        options: state.professors
                            .map((p) => p.displayName)
                            .toList(),
                        onSelected: (String selection) {
                          requestingProfessor.text = selection;

                          final selectedObject = state.professors.firstWhere(
                            (p) => p.displayName == selection,
                          );
                          context.read<NewProcedureCubit>().selectProfessor(
                            selectedObject.id,
                          );
                        },
                        labelStyle: unissTextTheme.bodySmall,
                        inputStyle: unissTextTheme.bodySmall,
                        border: OutlineInputBorder(),
                      ),

                      SizedBox(height: 16),

                      CommonAutocompleteField(
                        key: _amministratoreKey,
                        label: 'Amministratore assegnato',
                        options: state.assignedAdministrator
                            .map((p) => p.displayName)
                            .toList(),
                        onSelected: (String selection) {
                          // Quando l'utente clicca su un nome nella tendina, viene salvato il valore nel controller
                          assignedAdministrator.text = selection;
                          final selectedObject = state.assignedAdministrator
                              .firstWhere((p) => p.displayName == selection);
                          context.read<NewProcedureCubit>().selectAdministrator(
                            selectedObject.id,
                          );
                        },
                        labelStyle: unissTextTheme.bodySmall,
                        inputStyle: unissTextTheme.bodySmall,
                        border: OutlineInputBorder(),
                      ),

                      SizedBox(height: 16),

                      NumericField(
                        controller: procedureAmount,
                        label: 'Inserire un importo',
                        leftIcon: MediaConstants.euro,
                        labelStyle: unissTextTheme.bodySmall,
                        inputStyle: unissTextTheme.bodySmall,
                        labelColor: context.colors.gray,
                      ),

                      SizedBox(height: 16),

                      DateInputField(
                        controller: finalDeadline,
                        label: 'Inserire la deadline',
                        labelStyle: unissTextTheme.bodySmall,
                        inputStyle: unissTextTheme.bodySmall,
                        labelColor: context.colors.gray,
                      ),

                      SizedBox(height: 16),

                      Flex(
                        direction: isDesktop ? Axis.horizontal : Axis.vertical,
                        mainAxisAlignment: isDesktop
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.start,
                        children: [
                          UnissFilledButton(
                            text: 'Crea procedura',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (state.selectedProfessorId == null ||
                                    state.selectedAdministratorId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Seleziona professore e amministratore dalle opzioni suggerite.',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return; // Questo 'return' è il vero eroe: ferma l'esecuzione prima del crash!
                                }
                                String backendProcedureType = "";
                                if (procedureType == 'Beni di consumo') {
                                  backendProcedureType =
                                      "ORDINI_SU_MEPA_BENI_CONSUMO";
                                } else if (procedureType == 'Attrezzature') {
                                  // Assicurati che questo sia il nome esatto usato su MongoDB per l'altro template!
                                  backendProcedureType =
                                      "ORDINI_SU_MEPA_ATTREZZATURE";
                                }

                                final request = ProcedureRequest(
                                  procedureType: backendProcedureType,
                                  title: procedureName.text,
                                  amount:
                                      double.tryParse(procedureAmount.text) ??
                                      0.0,
                                  requestingProfessorId:
                                      state.selectedProfessorId!,
                                  assignedAdministratorId:
                                      state.selectedAdministratorId!,
                                  assignedRupId: widget.rupId,
                                  deadline: finalDeadline.text,
                                );

                                if (context.mounted) {
                                  context
                                      .read<NewProcedureCubit>()
                                      .submitProcedura(request);
                                }
                              }
                            },
                            width: isDesktop ? 200 : null,
                          ),
                          UnissFilledButton(
                            text: 'Svuota campi',
                            onPressed: _clearFields,
                            width: isDesktop ? 200 : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
