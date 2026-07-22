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

  /// Metodo UNICO per scaricare tutti i dati appena si apre la pagina
  Future<void> fetchInitialData() async {
    emit(state.copyWith(status: ProcedureStatus.loadingInitial));

    try {
      // Lanciamo entrambe le chiamate in parallelo usando Future.wait
      final results = await Future.wait([
        _repository.getProfessor(),
        _repository.getAssignedAdministrator(),
      ]);

      // results[0] è la lista restituita da getProfessor()
      // results[1] è la lista restituita da getAssignedAdministrator()

      // Se va a buon fine, sblocchiamo la UI e passiamo ENTRAMBE le liste
      emit(
        state.copyWith(
          status: ProcedureStatus.initial,
          professors: results[0],
          assignedAdministrator:
              results[1], // <-- Assicurati di aver aggiunto questa variabile in new_procedure_state.dart!
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
