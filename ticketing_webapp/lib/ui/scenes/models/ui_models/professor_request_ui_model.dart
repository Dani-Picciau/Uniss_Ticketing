import 'package:ticketing_webapp/ui/scenes/models/requests/professor_request_summary.dart';

class ProfessorRequestUiModel {
  final String id;
  final String requestingProfessorName;
  final String? assignedAdministratorName;
  final String subject;
  final String content;
  final String status;
  final DateTime createdAt;
  final String? linkedProcedureId;

  const ProfessorRequestUiModel({
    required this.id,
    required this.requestingProfessorName,
    required this.assignedAdministratorName,
    required this.subject,
    required this.content,
    required this.status,
    required this.createdAt,
    this.linkedProcedureId,
  });

  /// Factory che mappa il DTO (Freezed) nel modello della UI.
  /// È qui che avviene il "disaccoppiamento" tra backend e frontend visivo.
  factory ProfessorRequestUiModel.fromSummary(ProfessorRequestSummary summary) {
    return ProfessorRequestUiModel(
      id: summary.id,
      requestingProfessorName: summary.requestingProfessorName,
      assignedAdministratorName: summary.assignedAdministratorName,
      subject: summary.subject,
      content: summary.content,
      status: summary.status,
      createdAt: summary.createdAt,
      linkedProcedureId: summary.linkedProcedureId,
    );
  }
}
