import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/data/network/api_client.dart';
import 'package:ticketing_webapp/data/storage/session_manager.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/autocomplete_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/drop_down_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/input_field.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/numeric_field.dart';
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
  const OnMepaProcedure({super.key});

  @override
  State<OnMepaProcedure> createState() => _OnMepaProcedureState();
}

class _OnMepaProcedureState extends State<OnMepaProcedure> {
  final _formKey = GlobalKey<FormState>();

  String? procedureType;
  late final TextEditingController procedureName;
  late final TextEditingController requestingProfessor;
  late final TextEditingController assignedRUP;
  late final TextEditingController procedureAmount;

  @override
  void initState() {
    super.initState();
    // Inizializzati quando il widget viene creato
    procedureName = TextEditingController();
    requestingProfessor = TextEditingController();
    assignedRUP = TextEditingController();
    procedureAmount = TextEditingController();
  }

  @override
  void dispose() {
    // Vengono distrutti per liberare memoria
    procedureName.dispose();
    requestingProfessor.dispose();
    procedureAmount.dispose();
    super.dispose();
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
        return NewProcedureCubit(repository: repository)..fetchProfessors();
      },
      child: FadeIn(
        offset: const Offset(-50, 0),
        child: BlocConsumer<NewProcedureCubit, NewProcedureState>(
          listener: (context, state) {
            // --- GESTIONE NOTIFICHE E NAVIGAZIONE ---
            if (state.status == ProcedureStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildMessangerSnackBar(
                  context,
                  text: 'Procedura creata con successo!',
                  iconPath: MediaConstants
                      .success, // Assicurati di avere un'icona adatta
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
                state.status == ProcedureStatus.error) {
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
                    border: OutlineInputBorder(),
                    label: 'Professore richiedente',
                    // Passiamo la lista direttamente dallo stato del Cubit
                    options: state.professori,
                    onSelected: (String selection) {
                      // Quando l'utente clicca su un nome nella tendina,
                      // salviamo il valore nel controller che avevi già preparato
                      requestingProfessor.text = selection;
                    },
                  ),

                  SizedBox(height: 16),

                  CommonInputField(
                    controller: assignedRUP,
                    label: 'Amministratore assegnato',
                    labelStyle: unissTextTheme.bodySmall,
                    inputStyle: unissTextTheme.bodySmall,
                    labelColor: context.colors.gray,
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

                  UnissFilledButton(
                    text: 'Crea procedura',
                    onPressed: () => (),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
