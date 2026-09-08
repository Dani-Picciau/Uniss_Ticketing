import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/procedure_list_api.dart';
import 'procedure_list_state.dart';

class ProcedureListCubit extends Cubit<ProcedureListState> {
  final ProcedureListApi _procedureListApi;

  ProcedureListCubit({required ProcedureListApi procedureApi})
    : _procedureListApi = procedureApi,
      super(const ProcedureListState());

  Future<void> fetchProceduresByCategory(String procedureType) async {
    try {
      // Chiamata leggera che restituisce solo i summary
      final procedures = await _procedureListApi.getProceduresByType(
        procedureType,
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
