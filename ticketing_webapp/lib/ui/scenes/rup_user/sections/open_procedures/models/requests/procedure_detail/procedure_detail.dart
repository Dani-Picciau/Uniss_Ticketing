import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/completed_step/completed_step.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/node_status_request/node_status_request.dart';

part 'procedure_detail.freezed.dart';
part 'procedure_detail.g.dart';

@freezed
class ProcedureDetail with _$ProcedureDetail {
  const factory ProcedureDetail({
    required String id,
    required String title,
    required String procedureType,
    required String status,
    required String currentNodeId,
    required String currentEnabledRole,
    @Default([]) List<RequirementStatus> currentRequirementsStatus,
    @Default([]) List<CompletedStep> completedSteps,
    required DateTime createdAt,
    DateTime? deadline,
    int? duration,
  }) = _ProcedureDetail;

  factory ProcedureDetail.fromJson(Map<String, dynamic> json) =>
      _$ProcedureDetailFromJson(json);
}