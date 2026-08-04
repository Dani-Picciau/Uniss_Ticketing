import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/node_status_request/node_status_request.dart';

part 'completed_step.freezed.dart';
part 'completed_step.g.dart';

@freezed
class CompletedStep with _$CompletedStep {
  const factory CompletedStep({
    required String nodeId,
    required String stageName,
    required String completedByUserId,
    required DateTime completedAt,
    @Default([]) List<RequirementStatus> requirementsAtCompletion,
  }) = _CompletedStep;

  factory CompletedStep.fromJson(Map<String, dynamic> json) =>
      _$CompletedStepFromJson(json);
}
