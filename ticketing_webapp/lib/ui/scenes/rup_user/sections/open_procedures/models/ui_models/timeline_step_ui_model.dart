import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/timeline_dto/timeline_dto.dart';

class RequirementUiModel {
  final String name;
  final bool isSatisfied;

  const RequirementUiModel({required this.name, required this.isSatisfied});
}

class TimelineStepUiModel {
  final String nodeId;
  final String title;
  final String role;
  final String? notes;
  final List<RequirementUiModel> requirements;
  final bool isCompleted;
  final bool isActive;

  const TimelineStepUiModel({
    required this.nodeId,
    required this.title,
    required this.role,
    required this.notes,
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
        nodeId: item.nodeId,
        notes: item.notes,
        title: displayTitle,
        role: displayRole,
        requirements: uiRequirements,
        isCompleted: item.completed,
        isActive: item.active,
      );
    }).toList();
  }
}
