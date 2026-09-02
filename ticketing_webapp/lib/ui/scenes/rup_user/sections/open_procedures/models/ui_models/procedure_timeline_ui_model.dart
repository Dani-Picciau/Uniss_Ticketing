import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/timeline_dto/timeline_dto.dart';
import 'timeline_step_ui_model.dart';

class ProcedureTimelineUiModel {
  final String id;
  final String title;
  final String status;
  final DateTime? startDate; 
  final DateTime? endDate;   
  final List<TimelineStepUiModel> steps;

  const ProcedureTimelineUiModel({
    required this.id,
    required this.title,
    required this.status,
    this.startDate, 
    this.endDate,   
    required this.steps,
  });

  factory ProcedureTimelineUiModel.fromTimelineDto(TimelineDto dto) {
    return ProcedureTimelineUiModel(
      id: dto.procedureId,
      title: dto.title,
      status: dto.status,
      startDate: dto.startDate, 
      endDate: dto.endDate,     
      steps: TimelineStepUiModel.fromTimelineDto(dto),
    );
  }
}