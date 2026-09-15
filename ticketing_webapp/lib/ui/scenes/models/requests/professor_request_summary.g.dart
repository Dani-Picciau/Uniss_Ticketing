// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professor_request_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfessorRequestSummaryImpl _$$ProfessorRequestSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$ProfessorRequestSummaryImpl(
  id: json['id'] as String,
  requestingProfessorName: json['requestingProfessorName'] as String,
  assignedAdministratorName: json['assignedAdministratorName'] as String?,
  subject: json['subject'] as String,
  content: json['content'] as String,
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  linkedProcedureId: json['linkedProcedureId'] as String?,
);

Map<String, dynamic> _$$ProfessorRequestSummaryImplToJson(
  _$ProfessorRequestSummaryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'requestingProfessorName': instance.requestingProfessorName,
  'assignedAdministratorName': instance.assignedAdministratorName,
  'subject': instance.subject,
  'content': instance.content,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
  'linkedProcedureId': instance.linkedProcedureId,
};
