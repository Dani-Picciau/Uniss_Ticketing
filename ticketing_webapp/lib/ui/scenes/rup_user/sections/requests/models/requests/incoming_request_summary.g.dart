// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_request_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IncomingRequestSummaryImpl _$$IncomingRequestSummaryImplFromJson(
  Map<String, dynamic> json,
) => _$IncomingRequestSummaryImpl(
  id: json['id'] as String,
  requestingProfessorName: json['requestingProfessorName'] as String,
  subject: json['subject'] as String,
  content: json['content'] as String,
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  linkedProcedureId: json['linkedProcedureId'] as String?,
);

Map<String, dynamic> _$$IncomingRequestSummaryImplToJson(
  _$IncomingRequestSummaryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'requestingProfessorName': instance.requestingProfessorName,
  'subject': instance.subject,
  'content': instance.content,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
  'linkedProcedureId': instance.linkedProcedureId,
};
