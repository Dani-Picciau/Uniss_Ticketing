import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:ticketing_webapp/ui/components/common_input_field/utils/form_inputs.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/request/procedure_request.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/response/administrator_response/administrator_response.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/response/professor_response/professor_response.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/ui_model/user_ui_model.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/repositories/new_procedure_api.dart';
import 'new_procedure_state.dart';

class NewProcedureCubit extends Cubit<NewProcedureState> {
  // Dichiaro il repository come dipendenza
  final ProcedureRepository _repository;

  // Lo richiedo nel costruttore e inizializziamo lo stato
  NewProcedureCubit({required ProcedureRepository repository})
    : _repository = repository,
      super(const NewProcedureState());

  /// Metodo unico per scaricare tutti i dati come si apre il form
  Future<void> fetchInitialData() async {
    emit(state.copyWith(status: ProcedureStatus.loadingInitial));

    try {
      // Lanciamo entrambe le chiamate in parallelo usando Future.wait
      final results = await Future.wait([
        _repository.getProfessor(),
        _repository.getAssignedAdministrator(),
      ]);

      // 1. Estraiamo le liste grezze
      final rawProfessors = results[0] as List<ProfessorResponse>;
      final rawAdministrators = results[1] as List<AdministratorResponse>;

      // 2. Usiamo le Factory per trasformarle in una riga sola!
      final professorsUiList = rawProfessors
          .map((p) => UserUiModel.fromProfessor(p))
          .toList();
      final administratorsUiList = rawAdministrators
          .map((a) => UserUiModel.fromAdministrator(a))
          .toList();

      // 3. Passiamo alla UI i dati formattati
      emit(
        state.copyWith(
          status: ProcedureStatus.initial,
          professors: professorsUiList,
          assignedAdministrator: administratorsUiList,
        ),
      );
    } on ProcedureRepositoryException catch (e) {
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

  Future<void> submitProcedura(String rupId) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: ProcedureStatus.submitting));

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
          errorMessage: 'Amministratore non trovato. Seleziona un nome valido.',
        ),
      );
      return;
    }

    final request = ProcedureRequest(
      procedureType: state.procedureType.value,
      title: state.title.value,
      amount: double.tryParse(state.amount.value.replaceAll(',', '.')) ?? 0.0,
      requestingProfessorId: profOption.first.id,
      assignedAdministratorId: adminOption.first.id,
      assignedRupId: rupId,
      deadline: state.deadline.value,
    );

    try {
      await _repository.createProcedure(request);
      emit(state.copyWith(status: ProcedureStatus.success));
    } on ProcedureRepositoryException catch (e) {
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

  void titleChanged(String value) {
    final title = TextInput.dirty(value);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial, // Ad ogni submit devo resettare lo stato, altrimenti rimango in stato di errore
        title: title,
        isValid: Formz.validate([
          title,
          state.amount,
          state.deadline,
          state.procedureType,
          state.selectedProfessorId,
          state.selectedAdministratorId,
        ]),
      ),
    );
  }

  void amountChanged(String value) {
    final amount = AmountInput.dirty(value);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        amount: amount,
        isValid: Formz.validate([
          state.title,
          amount,
          state.deadline,
          state.procedureType,
          state.selectedProfessorId,
          state.selectedAdministratorId,
        ]),
      ),
    );
  }

  void deadlineChanged(String value) {
    final deadline = TextInput.dirty(value);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        deadline: deadline,
        isValid: Formz.validate([
          state.title,
          state.amount,
          deadline,
          state.procedureType,
          state.selectedProfessorId,
          state.selectedAdministratorId,
        ]),
      ),
    );
  }

  void procedureTypeChanged(String? value) {
    if (value == null) return;
    String backendType = "";
    if (value == 'Beni di consumo') backendType = "ORDINI_SU_MEPA_BENI_CONSUMO";
    if (value == 'Attrezzature') backendType = "ORDINI_SU_MEPA_ATTREZZATURE";

    final type = TextInput.dirty(backendType);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        procedureType: type,
        isValid: Formz.validate([
          state.title,
          state.amount,
          state.deadline,
          type,
          state.selectedProfessorId,
          state.selectedAdministratorId,
        ]),
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
          state.deadline,
          state.procedureType,
          state.selectedProfessorId,
          admin,
        ]),
      ),
    );
  }

  void resetForm() {
    // Svuota i form ma mantiene le liste scaricate dal DB
    emit(
      state.copyWith(
        title: const TextInput.pure(),
        amount: const AmountInput.pure(),
        deadline: const TextInput.pure(),
        procedureType: const TextInput.pure(),
        selectedProfessorId: const TextInput.pure(),
        selectedAdministratorId: const TextInput.pure(),
        isValid: false,
        status: ProcedureStatus.initial,
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
        isValid: Formz.validate([
          state.title,
          state.amount,
          state.deadline,
          state.procedureType,
          prof,
          state.selectedAdministratorId,
        ]),
      ),
    );
  }

  void administratorChanged(String name) {
    final admin = TextInput.dirty(name);
    emit(
      state.copyWith(
        status: ProcedureStatus.initial,
        selectedAdministratorId: admin,
        isValid: Formz.validate([
          state.title,
          state.amount,
          state.deadline,
          state.procedureType,
          state.selectedProfessorId,
          admin,
        ]),
      ),
    );
  }
}
