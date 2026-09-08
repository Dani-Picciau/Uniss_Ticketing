// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procedure_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProcedureSummaryImpl _$$ProcedureSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$ProcedureSummaryImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  currentNodeId: json['currentNodeId'] as String,
  status: json['status'] as String,
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  procedureType: json['procedureType'] as String,
  requestingProfessorName: json['requestingProfessorName'] as String,
  assignedAdministratorName: json['assignedAdministratorName'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  scholarshipHolderName: json['scholarshipHolderName'] as String?,
);

Map<String, dynamic> _$$ProcedureSummaryImplToJson(
  _$ProcedureSummaryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'currentNodeId': instance.currentNodeId,
  'status': instance.status,
  'deadline': instance.deadline?.toIso8601String(),
  'procedureType': instance.procedureType,
  'requestingProfessorName': instance.requestingProfessorName,
  'assignedAdministratorName': instance.assignedAdministratorName,
  'createdAt': instance.createdAt.toIso8601String(),
  'scholarshipHolderName': instance.scholarshipHolderName,
};
