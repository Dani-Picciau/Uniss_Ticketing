import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/repositories/new_procedure_api.dart';
import 'new_procedure_state.dart';

class NewProcedureCubit extends Cubit<NewProcedureState> {
  // 1. Dichiariamo il repository come dipendenza
  final ProcedureRepository _repository;

  // 2. Lo richiediamo nel costruttore e inizializziamo lo stato
  NewProcedureCubit({required ProcedureRepository repository})
    : _repository = repository,
      super(const NewProcedureState());

  /// Metodo per scaricare i dati appena si apre la pagina
  Future<void> fetchProfessors() async {
    emit(state.copyWith(status: ProcedureStatus.loadingInitial));

    try {
      // Effettuiamo la chiamata HTTP
      final professorsList = await _repository.getProfessor();

      // Se va a buon fine, sblocchiamo la UI e passiamo la lista
      emit(
        state.copyWith(
          status: ProcedureStatus.initial,
          professori: professorsList,
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

  // Metodo per salvare i dati finali (da completare più avanti)
  Future<void> submitProcedura(Map<String, dynamic> formData) async {
    // Qui andrà la logica di salvataggio...
  }
}
