import 'package:ticketing_webapp/ui/scenes/rup_user/sections/requests/models/requests/incoming_request_summary.dart';

class ProfessorRequestUiModel {
  final String id;
  final String requestingProfessorName;
  final String subject;
  final String content;
  final String status;
  final DateTime createdAt;
  final String? linkedProcedureId;

  const ProfessorRequestUiModel({
    required this.id,
    required this.requestingProfessorName,
    required this.subject,
    required this.content,
    required this.status,
    required this.createdAt,
    this.linkedProcedureId,
  });

  /// Factory che mappa il DTO (Freezed) nel modello della UI.
  /// È qui che avviene il "disaccoppiamento" tra backend e frontend visivo.
  factory ProfessorRequestUiModel.fromSummary(IncomingRequestSummary summary) {
    return ProfessorRequestUiModel(
      id: summary.id,
      requestingProfessorName: summary.requestingProfessorName,
      subject: summary.subject,
      content: summary.content,
      status: summary.status,
      createdAt: summary.createdAt,
      linkedProcedureId: summary.linkedProcedureId,
    );
  }
}
