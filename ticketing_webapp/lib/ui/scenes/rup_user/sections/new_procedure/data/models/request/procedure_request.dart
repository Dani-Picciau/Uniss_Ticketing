import 'package:freezed_annotation/freezed_annotation.dart';

part 'procedure_request.freezed.dart';
part 'procedure_request.g.dart';

@freezed
class ProcedureRequest with _$ProcedureRequest {
  const factory ProcedureRequest({
    required String procedureType,
    required String title,
    required double amount,
    required String requestingProfessorId,
    required String assignedRupId,
    required String assignedAdministratorId,
    required String deadline,
  }) = _ProcedureRequest;

  factory ProcedureRequest.fromJson(Map<String, dynamic> json) =>
      _$ProcedureRequestFromJson(json);
}
