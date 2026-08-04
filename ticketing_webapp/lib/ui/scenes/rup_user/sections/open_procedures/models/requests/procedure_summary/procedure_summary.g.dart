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
  procedureType: json['procedureType'] as String,
  status: json['status'] as String,
  currentNodeId: json['currentNodeId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
);

Map<String, dynamic> _$$ProcedureSummaryImplToJson(
  _$ProcedureSummaryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'procedureType': instance.procedureType,
  'status': instance.status,
  'currentNodeId': instance.currentNodeId,
  'createdAt': instance.createdAt.toIso8601String(),
  'deadline': instance.deadline?.toIso8601String(),
};
