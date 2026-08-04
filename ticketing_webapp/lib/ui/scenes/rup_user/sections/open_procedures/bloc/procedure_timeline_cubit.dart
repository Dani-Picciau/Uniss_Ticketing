import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/features/repositories/procedure_detail_api.dart'; // Adatta il path alla tua API
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/ui_models/procedure_timeline_ui_model.dart';
import 'procedure_timeline_state.dart';

class ProcedureTimelineCubit extends Cubit<ProcedureTimelineState> {
  final ProcedureDetailApi _detailApi;

  ProcedureTimelineCubit({required ProcedureDetailApi detailApi})
    : _detailApi = detailApi,
      super(const ProcedureTimelineState());

  Future<void> fetchTimeline(String procedureId) async {
    emit(state.copyWith(status: ProcedureTimelineStatus.loading));

    try {
      final detail = await _detailApi.getProcedureById(procedureId);

      // Trasformiamo subito la response grezza nel modello UI pulito:
      final uiModel = ProcedureTimelineUiModel.fromProcedureDetail(detail);

      emit(
        state.copyWith(
          status: ProcedureTimelineStatus.success,
          uiModel: uiModel,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProcedureTimelineStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Metodo di utility se volessi svuotare il pannello di destra (es. deselezionando un item)
  void clearSelection() {
    emit(const ProcedureTimelineState(status: ProcedureTimelineStatus.initial));
  }
}
