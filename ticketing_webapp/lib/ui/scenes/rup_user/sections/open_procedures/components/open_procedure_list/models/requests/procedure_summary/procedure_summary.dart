import 'package:freezed_annotation/freezed_annotation.dart';

part 'procedure_summary.freezed.dart';
part 'procedure_summary.g.dart';

@freezed
class ProcedureSummary with _$ProcedureSummary {
  const factory ProcedureSummary({
    required String id,
    required String title,
    required String procedureType,
    required String status,
    required String currentNodeId,
    required DateTime createdAt,
    DateTime? deadline,
  }) = _ProcedureSummary;

  factory ProcedureSummary.fromJson(Map<String, dynamic> json) =>
      _$ProcedureSummaryFromJson(json);
}
