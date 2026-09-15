import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/timeline_dto/timeline_dto.dart';

class RequirementUiModel {
  final String name;
  final bool isSatisfied;

  const RequirementUiModel({required this.name, required this.isSatisfied});
}

class TimelineStepUiModel {
  final String nodeId;
  final String title;
  final String rupBadge;
  final String adminBadge;
  final String? notes;
  final List<RequirementUiModel> requirements;
  final bool isCompleted;
  final bool isActive;

  const TimelineStepUiModel({
    required this.nodeId,
    required this.title,
    required this.rupBadge,
    required this.adminBadge,
    required this.notes,
    required this.requirements,
    this.isCompleted = false,
    this.isActive = false,
  });

  /// Mappa direttamente la lista di step già costruita dal backend Java
  static List<TimelineStepUiModel> fromTimelineDto(TimelineDto dto) {
    final rupName = dto.assignedRupName ?? 'Non specificato';
    final globalAdminName = dto.assignedAdminName ?? 'Non assegnato';

    return dto.steps.map((item) {
      final displayTitle = item.stageName.isNotEmpty
          ? item.stageName
          : item.nodeId;

      // Mappiamo i singoli requisiti inviati dal DB Java:
      final uiRequirements = item.requirements
          .map(
            (r) => RequirementUiModel(name: r.name, isSatisfied: r.satisfied),
          )
          .toList();

      String stepAdminName;
      if (item.completed && item.completedByUserName != null) {
        // Se lo step è concluso, mostriamo chi l'ha effettivamente fatto
        stepAdminName = item.completedByUserName!;
      } else {
        // Se lo step è attivo o futuro, mostriamo l'amministratore assegnato in questo momento
        stepAdminName = globalAdminName;
      }

      return TimelineStepUiModel(
        nodeId: item.nodeId,
        notes: item.notes,
        title: displayTitle,
        rupBadge: 'RUP: $rupName',
        adminBadge: 'Incaricato: $stepAdminName',
        requirements: uiRequirements,
        isCompleted: item.completed,
        isActive: item.active,
      );
    }).toList();
  }
}
