import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/procedure_detail/procedure_detail.dart';

class TimelineStepUiModel {
  final String title;
  final String role;
  final List<String> requirements;
  final bool isCompleted;
  final bool isActive;

  const TimelineStepUiModel({
    required this.title,
    required this.role,
    required this.requirements,
    this.isCompleted = false,
    this.isActive = false,
  });

  static List<TimelineStepUiModel> fromProcedureDetail(ProcedureDetail detail) {
    final steps = <TimelineStepUiModel>[];

    // 1. Tutti gli step completati (dallo storico)
    for (final completed in detail.completedSteps) {
      steps.add(
        TimelineStepUiModel(
          title: completed.stageName.isNotEmpty
              ? completed.stageName
              : completed.nodeId,
          role: 'COMPLETATO',
          requirements: completed.requirementsAtCompletion
              .map((r) => r.requirementName)
              .toList(),
          isCompleted: true,
        ),
      );
    }

    // 2. Lo step attualmente in corso (se la procedura è ancora aperta)
    final bool isFinished =
        detail.currentNodeId == 'FINITO' || detail.status == 'COMPLETATA';

    if (!isFinished) {
      steps.add(
        TimelineStepUiModel(
          title: detail.currentNodeId,
          role: detail.currentEnabledRole,
          requirements: detail.currentRequirementsStatus
              .map((r) => r.requirementName)
              .toList(),
          isActive: true,
        ),
      );
    }

    return steps;
  }
}
