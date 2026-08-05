import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/timeline_dto/timeline_dto.dart';

class RequirementUiModel {
  final String name;
  final bool isSatisfied;

  const RequirementUiModel({required this.name, required this.isSatisfied});
}

class TimelineStepUiModel {
  final String title;
  final String role;
  final List<RequirementUiModel> requirements;
  final bool isCompleted;
  final bool isActive;

  const TimelineStepUiModel({
    required this.title,
    required this.role,
    required this.requirements,
    this.isCompleted = false,
    this.isActive = false,
  });

  /// Mappa direttamente la lista di step già costruita dal backend Java
  static List<TimelineStepUiModel> fromTimelineDto(TimelineDto dto) {
    return dto.steps.map((item) {
      final displayTitle = item.stageName.isNotEmpty
          ? item.stageName
          : item.nodeId;
      final displayRole = item.completed
          ? 'COMPLETATO'
          : (item.enabledRole ?? 'DA DEFINIRE');

      // Mappiamo i singoli requisiti inviati dal DB Java:
      final uiRequirements = item.requirements
          .map(
            (r) => RequirementUiModel(name: r.name, isSatisfied: r.satisfied),
          )
          .toList();

      return TimelineStepUiModel(
        title: displayTitle,
        role: displayRole,
        requirements: uiRequirements,
        isCompleted: item.completed,
        isActive: item.active,
      );
    }).toList();
  }
}

  /*   static List<TimelineStepUiModel> fromProcedureDetail(ProcedureDetail detail) {
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
  } */

