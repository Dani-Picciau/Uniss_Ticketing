import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/request/procedure_request.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/response/administrator_response/administrator_response.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/response/professor_response/professor_response.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/ui_model/user_ui_model.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/repositories/new_procedure_api.dart';
import 'new_procedure_state.dart';

class NewProcedureCubit extends Cubit<NewProcedureState> {
  // 1. Dichiariamo il repository come dipendenza
  final ProcedureRepository _repository;

  // 2. Lo richiediamo nel costruttore e inizializziamo lo stato
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

  Future<void> submitProcedura(ProcedureRequest request) async {
    emit(state.copyWith(status: ProcedureStatus.submitting));

    try {
      await _repository.createProcedure(request);

      // Se tutto va bene, emettiamo lo stato di successo.
      // Il BlocListener nella UI intercetterà questo stato e mostrerà la SnackBar verde!
      emit(state.copyWith(status: ProcedureStatus.success));
    } on ProcedureRepositoryException catch (e) {
      emit(
        state.copyWith(status: ProcedureStatus.error, errorMessage: e.message),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProcedureStatus.error,
          errorMessage: 'Errore imprevisto durante il salvataggio.',
        ),
      );
    }
  }

  void selectProfessor(String id) {
    emit(state.copyWith(selectedProfessorId: id));
  }

  void selectAdministrator(String id) {
    emit(state.copyWith(selectedAdministratorId: id));
  }
}
