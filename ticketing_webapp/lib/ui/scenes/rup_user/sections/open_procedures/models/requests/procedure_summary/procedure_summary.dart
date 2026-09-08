import 'package:freezed_annotation/freezed_annotation.dart';

part 'procedure_summary.freezed.dart';
part 'procedure_summary.g.dart';

//Se voglio aggiungere qualche dato in più da visualizzare per gli item della lista mi basta specificarli qui. Verranno presi da procedure.java, passando per procedure_controller.java, quindi devo assicurarmi che il nome dei campi combacino.
@freezed
class ProcedureSummary with _$ProcedureSummary {
  const factory ProcedureSummary({
    required String id,
    required String title,
    required String currentNodeId,
    required String status,
    required DateTime? deadline,
    required String procedureType,

    //Another Summary info
    required String requestingProfessorName,
    required String assignedAdministratorName,
    required DateTime createdAt,
    required String? scholarshipHolderName,
  }) = _ProcedureSummary;

  factory ProcedureSummary.fromJson(Map<String, dynamic> json) =>
      _$ProcedureSummaryFromJson(json);
}
