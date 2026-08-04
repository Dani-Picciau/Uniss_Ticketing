// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procedure_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProcedureDetailImpl _$$ProcedureDetailImplFromJson(
  Map<String, dynamic> json,
) => _$ProcedureDetailImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  procedureType: json['procedureType'] as String,
  status: json['status'] as String,
  currentNodeId: json['currentNodeId'] as String,
  currentEnabledRole: json['currentEnabledRole'] as String,
  currentRequirementsStatus:
      (json['currentRequirementsStatus'] as List<dynamic>?)
          ?.map((e) => RequirementStatus.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  completedSteps:
      (json['completedSteps'] as List<dynamic>?)
          ?.map((e) => CompletedStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  duration: (json['duration'] as num?)?.toInt(),
);

Map<String, dynamic> _$$ProcedureDetailImplToJson(
  _$ProcedureDetailImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'procedureType': instance.procedureType,
  'status': instance.status,
  'currentNodeId': instance.currentNodeId,
  'currentEnabledRole': instance.currentEnabledRole,
  'currentRequirementsStatus': instance.currentRequirementsStatus,
  'completedSteps': instance.completedSteps,
  'createdAt': instance.createdAt.toIso8601String(),
  'deadline': instance.deadline?.toIso8601String(),
  'duration': instance.duration,
};
