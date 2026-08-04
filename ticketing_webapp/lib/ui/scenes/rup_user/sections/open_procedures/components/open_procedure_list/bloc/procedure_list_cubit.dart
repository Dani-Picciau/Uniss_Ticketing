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
      final procedures = await _procedureListApi.getproceduresByType(
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
        state.copyWith(
          status: ProcedureListStatus.error,
          errorMessage: '$e',
        ),
      );
    }
  }
}
