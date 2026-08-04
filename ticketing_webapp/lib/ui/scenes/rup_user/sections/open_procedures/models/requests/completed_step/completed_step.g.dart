// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompletedStepImpl _$$CompletedStepImplFromJson(Map<String, dynamic> json) =>
    _$CompletedStepImpl(
      nodeId: json['nodeId'] as String,
      stageName: json['stageName'] as String,
      completedByUserId: json['completedByUserId'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      requirementsAtCompletion:
          (json['requirementsAtCompletion'] as List<dynamic>?)
              ?.map(
                (e) => RequirementStatus.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CompletedStepImplToJson(_$CompletedStepImpl instance) =>
    <String, dynamic>{
      'nodeId': instance.nodeId,
      'stageName': instance.stageName,
      'completedByUserId': instance.completedByUserId,
      'completedAt': instance.completedAt.toIso8601String(),
      'requirementsAtCompletion': instance.requirementsAtCompletion,
    };
