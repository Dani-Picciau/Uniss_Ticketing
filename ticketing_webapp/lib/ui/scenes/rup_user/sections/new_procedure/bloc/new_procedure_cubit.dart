import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ticketing_webapp/features/repositories/procedure_api.dart';
import 'package:ticketing_webapp/features/repositories/professor_request_api.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/utils/form_inputs.dart';
import 'package:ticketing_webapp/ui/scenes/models/requests/professor_request_summary.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/models/requests/procedure_request.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/models/response/administrator_response/administrator_response.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/models/response/professor_response/professor_response.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/new_procedure/models/ui_model/user_ui_model.dart';

import 'new_procedure_state.dart';

class NewProcedureCubit extends Cubit<NewProcedureState> {
  // Dichiaro il repository come dipendenza
  final ProcedureApi _procedureApi;
  final ProfessorRequestApi
  _professorRequestApi; // Serve per poter accedere ai metodi e scaricare quindi le richieste dei professori compilando il form
  final bool isMepa;
  final bool isSchoolarship;

  // Lo richiedo nel costruttore e inizializziamo lo stato
  NewProcedureCubit({
    required ProcedureApi procedureApi,
    required ProfessorRequestApi professorRequestApi,
    required this.isMepa,
    required this.isSchoolarship,
  }) : _procedureApi = procedureApi,
       _professorRequestApi = professorRequestApi,
       super(const NewProcedureState());

  /// Metodo unico per scaricare tutti i dati come si apre il form
  Future<void> fetchInitialData() async {
    emit(state.copyWith(status: ProcedureStatus.loadingInitial));

    try {
      // Lanciamo entrambe le chiamate in parallelo usando Future.wait
      final results = await Future.wait([
        _procedureApi.getProfessor(),
        _procedureApi.getAssignedAdministrator(),
        _professorRequestApi.getRequestsByStatus('In attesa'),
      ]);

      // 1. Estraiamo le liste grezze
      final rawProfessors = results[0] as List<ProfessorResponse>;
      final rawAdministrators = results[1] as List<AdministratorResponse>;
      final rawPendingRequests = results[2] as List<ProfessorRequestSummary>;

      // 2. Usiamo le Factory per trasformarle in una riga sola
      final professorsUiList = rawProfessors
          .map((p) => UserUiModel.fromProfessor(p))
          .toList();
      final administratorsUiList = rawAdministrators
          .map((a) => UserUiModel.fromAdministrator(a))
          .toList();

      // Passiamo alla UI i dati formattati
      emit(
        state.copyWith(
          status: ProcedureStatus.initial,
          professors: professorsUiList,
          assignedAdministrator: administratorsUiList,
          pendingRequests: rawPendingRequests,
          duration: isSchoolarship
              ? const AmountInput.dirty('3')
              : const AmountInput.pure(),
        ),
      );
    } on ProcedureException catch (e) {
      emit(
        state.copyWith(status: ProcedureStatus.error, errorMessage: e.message),
      );
    } catch (e) {
      // Fallback per errori generici non previsti
      emit(
        state.copyWith(
          status: ProcedureStatus.error,
          errorMessage: 'Errore critico durante l\'inizializzazione.',
        ),
      );
    }
  }

  Future<void> fetchRenewableScholarships() async {
    if (state.renewableScholarships.isNotEmpty) return; // già in cache

    try {
      final list = await _procedureApi.getProcedures(
        procedureType: 'BORSE_DI_STUDIO_NUOVA',
      );
      emit(state.copyWith(renewableScholarships: list));
    } catch (e) {
      // Non blocchiamo l'intero form per un errore su questa lista:
      // l'utente vedrà semplicemente un autocomplete vuoto e potrà
      // riprovare cambiando tipo avanti e indietro.
    }
  }

  Future<void> submitProcedura(String rupId) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: ProcedureStatus.submitting));

    try {
      if (state.procedureType.value == 'BORSE_DI_STUDIO_RINNOVO') {
        final renewalOption = state.renewableScholarships
            .where((p) => p.title == state.selectedRenewalProcedureId.value)
            .toList();

        if (renewalOption.isEmpty) {
          emit(
            state.copyWith(
              status: ProcedureStatus.error,
              errorMessage: 'Borsa non trovata.',
            ),
          );
          return;
        }

        // Chiamata all'API per il rinnovo
        await _procedureApi.renewScholarship(
          renewalOption.first.id,
          int.parse(state.duration.value),
        );
      } else {
        final profOption = state.professors
            .where((p) => p.displayName == state.selectedProfessorId.value)
            .toList();
        final adminOption = state.assignedAdministrator
            .where((p) => p.displayName == state.selectedAdministratorId.value)
            .toList();

        if (profOption.isEmpty) {
          emit(
            state.copyWith(
              status: ProcedureStatus.error,
              errorMessage: 'Professore non trovato. Seleziona un nome valido.',
            ),
          );
          return;
        }
        if (adminOption.isEmpty) {
          emit(
            state.copyWith(
              status: ProcedureStatus.error,
              errorMessage:
                  'Amministratore non trovato. Seleziona un nome valido.',
            ),
          );
          return;
        }

        String? foundTicketId;
        if (state.selectedPendingRequestId.value.isNotEmpty) {
          final requestOption = state.pendingRequests
              .where(
                (r) =>
                    '${r.subject} - ${r.requestingProfessorName}' ==
                    state.selectedPendingRequestId.value,
              )
              .toList();

          if (requestOption.isNotEmpty) {
            foundTicketId = requestOption.first.id;
          }
        }

        final request = ProcedureRequest(
          procedureType: state.procedureType.value,
          title: state.title.value,
          amount:
              double.tryParse(state.amount.value.replaceAll(',', '.')) ?? 0.0,
          requestingProfessorId: profOption.first.id,
          assignedAdministratorId: adminOption.first.id,
          assignedRupId: rupId,
          deadline: state.deadline.value,
          duration: isSchoolarship ? int.tryParse(state.duration.value) : null,
          startDate: isSchoolarship ? state.startDate.value : null,
          scholarshipHolderName: isSchoolarship
              ? state.scholarshipHolder.value
              : null,
          ticketRequestId: foundTicketId,
        );

        final String newProcedureId = await _procedureApi.createProcedure(
          request,
        );

        if (foundTicketId != null) {
          await _professorRequestApi.linkProcedureToRequest(
            foundTicketId,
            newProcedureId,
          );
        }
      }
      emit(state.copyWith(status: ProcedureStatus.success));
    } on ProcedureException catch (e) {
      emit(
        state.copyWith(status: ProcedureStatus.error, errorMessage: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProcedureStatus.error,
          errorMessage: 'Errore imprevisto.',
        ),
      );
    }
  }

  //=====================================================

  List<FormzInput> _fieldsToValidate({
    TextInput? title,
    AmountInput? amount,
    AmountInput? duration,
    TextInput? deadline,
    TextInput? procedureType,
    TextInput? selectedProfessorId,
    TextInput? selectedAdministratorId,
    TextInput? selectedRenewalProcedureId,
    TextInput? startDate,
    TextInput? scholarshipHolder,
  }) {
    final effectiveType = procedureType ?? state.procedureType;
    final isRenewal = effectiveType.value == 'BORSE_DI_STUDIO_RINNOVO';
    return [
      title ?? state.title,
      if (!isRenewal) amount ?? state.amount,
      if (isSchoolarship) duration ?? state.duration,
      if (isSchoolarship && !isRenewal) startDate ?? state.startDate,
      if (isSchoolarship) scholarshipHolder ?? state.scholarshipHolder,
      deadline ?? state.deadline,
      effectiveType,
      selectedProfessorId ?? state.selectedProfessorId,
      selectedAdministratorId ?? state.selectedAdministratorId,
      // Il campo di rinnovo entra in validazione SOLO se il tipo
      // attualmente selezionato è "Rinnovo borsa".
      if (isRenewal)
        selectedRenewalProcedureId ?? state.selectedRenewalProcedureId,
    ];
  }

  void titleChanged(String value) {
    final title = TextInput.dirty(value);
    emit(
      state.copyWith(
        status: ProcedureStatus
            .initial, // Ad ogni submit devo resettare lo stato, altrimenti rimango in stato di errore
        title: title,
        isValid: Formz.validate(_fieldsToValidate(title: title)),
      ),
    );
  }

  void amountChanged(String value) {
    final amount = AmountInput.dirty(value);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        amount: amount,
        isValid: Formz.validate(_fieldsToValidate(amount: amount)),
      ),
    );
  }

  void deadlineChanged(String value) {
    final deadline = TextInput.dirty(value);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        deadline: deadline,
        isValid: Formz.validate(_fieldsToValidate(deadline: deadline)),
      ),
    );
  }

  void durationChanged(String value) {
    final duration = AmountInput.dirty(value);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        duration: duration,
        isValid: Formz.validate(_fieldsToValidate(duration: duration)),
      ),
    );
  }

  void procedureTypeChanged(String? value) {
    if (value == null) return;
    String backendType = "";

    if (!isMepa && !isSchoolarship) {
      switch (value) {
        case 'Beni di consumo':
          backendType = "ORDINI_FUORI_MEPA_BENI_CONSUMO";
          break;
        case 'Pubblicazioni':
          backendType = "PUBBLICAZIONI_ESTERE";
          break;
        default:
          null;
      }
    } else {
      switch (value) {
        case 'Beni di consumo':
          backendType = "ORDINI_SU_MEPA_BENI_CONSUMO";
          break;
        case 'Attrezzature':
          backendType = "ORDINI_SU_MEPA_ATTREZZATURE";
          break;
        case 'Servizi':
          backendType = "ORDINI_SERVIZI_SU_MEPA";
          break;
        case 'Nuova borsa':
          backendType = "BORSE_DI_STUDIO_NUOVA";
          break;
        case 'Rinnovo borsa':
          backendType = "BORSE_DI_STUDIO_RINNOVO";
          break;
        default:
          null;
      }
    }

    final type = TextInput.dirty(backendType);

    // Controllo per il reset dei mesi quando si passa da "rinnovo" a "nuova"
    AmountInput newDuration = state.duration;
    if (isSchoolarship) {
      final currentDurationInt = int.tryParse(state.duration.value) ?? 3;

      // Se l'utente torna a "Nuova borsa" e aveva impostato 1 o 2 mesi per il rinnovo, forziamo il reset a 3
      if (backendType == 'BORSE_DI_STUDIO_NUOVA' && currentDurationInt < 3) {
        newDuration = const AmountInput.dirty('3');
      }
    }

    // Se l'utente ha appena scelto "Rinnovo borsa", carichiamo la
    // lista delle borse rinnovabili (se non già in cache).
    if (backendType == 'BORSE_DI_STUDIO_RINNOVO') {
      fetchRenewableScholarships();
    }
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        procedureType: type,
        duration: newDuration,
        isValid: Formz.validate(
          _fieldsToValidate(
            procedureType: type,
            duration:
                newDuration, // <- Assicuriamoci che Formz validi il nuovo stato
          ),
        ),
      ),
    );
  }

  void selectProfessor(String id) {
    final prof = TextInput.dirty(id);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        selectedProfessorId: prof,
        isValid: Formz.validate([
          state.title,
          state.amount,
          if (isSchoolarship) state.duration,
          state.deadline,
          state.procedureType,
          prof,
          state.selectedAdministratorId,
        ]),
      ),
    );
  }

  void selectAdministrator(String id) {
    final admin = TextInput.dirty(id);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        selectedAdministratorId: admin,
        isValid: Formz.validate([
          state.title,
          state.amount,
          if (isSchoolarship) state.duration,
          state.deadline,
          state.procedureType,
          state.selectedProfessorId,
          admin,
        ]),
      ),
    );
  }

  void professorChanged(String name) {
    final prof = TextInput.dirty(name);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        selectedProfessorId:
            prof, // Usiamo questa variabile per conservare il nome
        isValid: Formz.validate(_fieldsToValidate(selectedProfessorId: prof)),
      ),
    );
  }

  void administratorChanged(String name) {
    final admin = TextInput.dirty(name);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        selectedAdministratorId: admin,
        isValid: Formz.validate(
          _fieldsToValidate(selectedAdministratorId: admin),
        ),
      ),
    );
  }

  // Chiamato quando l'utente sceglie/scrive nell'autocomplete
  // "Borsa da rinnovare".
  void renewalProcedureChanged(String value) {
    final renewal = TextInput.dirty(value);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        selectedRenewalProcedureId: renewal,
        isValid: Formz.validate(
          _fieldsToValidate(selectedRenewalProcedureId: renewal),
        ),
      ),
    );
  }

  void startDateChanged(String value) {
    final start = TextInput.dirty(value);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        startDate: start,
        isValid: Formz.validate(
          _fieldsToValidate(startDate: start),
        ), // Ricordati di aggiungere startDate in _fieldsToValidate!
      ),
    );
  }

  void scholarshipHolderChanged(String value) {
    final holder = TextInput.dirty(value);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        scholarshipHolder: holder,
        isValid: Formz.validate(_fieldsToValidate(scholarshipHolder: holder)),
      ),
    );
  }

  void pendingRequestChanged(String subjectTitle) {
    final request = TextInput.dirty(subjectTitle);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        selectedPendingRequestId: request,
        // Non aggiungo il "Formz.validate" perché è un campo opzionale
      ),
    );
  }

  void resetForm() {
    emit(
      state.copyWith(
        title: const TextInput.pure(),
        amount: const AmountInput.pure(),
        duration: isSchoolarship
            ? const AmountInput.dirty('3')
            : const AmountInput.pure(),
        deadline: const TextInput.pure(),
        startDate: const TextInput.pure(),
        procedureType: const TextInput.pure(),
        selectedProfessorId: const TextInput.pure(),
        selectedAdministratorId: const TextInput.pure(),
        selectedRenewalProcedureId: const TextInput.pure(),
        scholarshipHolder: const TextInput.pure(),
        isValid: false,
        status: ProcedureStatus.initial,
        // Ometto renewableScholarships, professors e assignedAdministrator e cancello tutto il resto singolarmente per evitare di perdere i dati scaricati tramite le chiamate API
      ),
    );
  }
}
