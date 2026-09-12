import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/procedure_api.dart';
import 'procedure_list_state.dart';

class ProcedureListCubit extends Cubit<ProcedureListState> {
  final ProcedureApi _procedureListApi;

  ProcedureListCubit({required ProcedureApi procedureApi})
    : _procedureListApi = procedureApi,
      super(const ProcedureListState());

  // Rinominato per renderlo generico e usiamo i parametri nominali opzionali
  Future<void> fetchProcedures({
    String? procedureType,
    String? status,
    String? viewAs,
  }) async {
    // Notifichiamo la UI del caricamento iniziale
    emit(state.copyWith(status: ProcedureListStatus.loading));

    try {
      // Passiamo entrambi i parametri all'API (se uno è null, l'API lo ignorerà)
      final procedures = await _procedureListApi.getProcedures(
        procedureType: procedureType,
        status: status,
        viewAs: viewAs,
      );

      if (procedures.isEmpty) {
        emit(state.copyWith(status: ProcedureListStatus.empty));
      } else {
        emit(
          state.copyWith(
            status: ProcedureListStatus.success,
            procedures: procedures,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: ProcedureListStatus.error, errorMessage: '$e'),
      );
    }
  }

  Future<void> deleteProcedure(String procedureId) async {
    // Notifichiamo la UI che stiamo caricando
    emit(state.copyWith(status: ProcedureListStatus.loading));

    try {
      // Chiamata all'API
      _procedureListApi.deleteProcedure(procedureId);

      // Se ha successo, filtriamo la lista attuale rimuovendo quella eliminata
      final updatedList = state.procedures
          .where((procedure) => procedure.id != procedureId)
          .toList();

      // Aggiorniamo lo stato con la nuova lista e il successo
      emit(
        state.copyWith(
          status: ProcedureListStatus.deleteSuccess,
          procedures:
              updatedList, // La lista aggiornata (senza la procedura eliminata)
        ),
      );
    } catch (e) {
      // Gestione errore
      emit(
        state.copyWith(
          status: ProcedureListStatus.deleteError,
          errorMessage: '$e',
        ),
      );
    }
  }
}
