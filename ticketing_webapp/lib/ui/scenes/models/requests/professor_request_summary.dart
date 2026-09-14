import 'package:freezed_annotation/freezed_annotation.dart';

part 'professor_request_summary.freezed.dart';
part 'professor_request_summary.g.dart';

@freezed
class ProfessorRequestSummary with _$ProfessorRequestSummary {
  const factory ProfessorRequestSummary({
    required String id,
    required String requestingProfessorName,
    required String? assignedAdministratorName,
    required String subject,
    required String content,
    required String status,
    required DateTime createdAt,
    String? linkedProcedureId,
  }) = _ProfessorRequestSummary;

  factory ProfessorRequestSummary.fromJson(Map<String, dynamic> json) =>
      _$ProfessorRequestSummaryFromJson(json);
}
