import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/procedure_detail/procedure_detail.dart';
import 'timeline_step_ui_model.dart';

// Questo è il UiModel "di pagina": rappresenta tutto ciò che
// ProcedureTimelineView deve mostrare, non solo la lista degli step.
// TimelineStepUiModel resta il UiModel "di riga" — non sparisce, diventa
// semplicemente UNO dei campi di questo modello più grande, invece di
// essere l'unica cosa passata al widget.
class ProcedureTimelineUiModel {
  final String id;
  final String title;
  final String status;
  final List<TimelineStepUiModel> steps;

  const ProcedureTimelineUiModel({
    required this.id,
    required this.title,
    required this.status,
    required this.steps,
  });

  factory ProcedureTimelineUiModel.fromProcedureDetail(ProcedureDetail detail) {
    return ProcedureTimelineUiModel(
      id: detail.id,
      title: detail.title,
      status: detail.status,
      // Riusiamo la logica già scritta in TimelineStepUiModel per la
      // parte "lista" — non la duplichiamo qui.
      steps: TimelineStepUiModel.fromProcedureDetail(detail),
    );
  }
}
