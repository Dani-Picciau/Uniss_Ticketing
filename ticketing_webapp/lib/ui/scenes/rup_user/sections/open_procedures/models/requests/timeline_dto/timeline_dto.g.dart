// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimelineDtoImpl _$$TimelineDtoImplFromJson(Map<String, dynamic> json) =>
    _$TimelineDtoImpl(
      procedureId: json['procedureId'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => TimelineStepDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TimelineDtoImplToJson(_$TimelineDtoImpl instance) =>
    <String, dynamic>{
      'procedureId': instance.procedureId,
      'title': instance.title,
      'status': instance.status,
      'steps': instance.steps,
    };

_$TimelineStepDtoImpl _$$TimelineStepDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TimelineStepDtoImpl(
  nodeId: json['nodeId'] as String,
  stageName: json['stageName'] as String,
  enabledRole: json['enabledRole'] as String?,
  requirementsToSatisfy:
      (json['requirementsToSatisfy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  completed: json['completed'] as bool,
  active: json['active'] as bool,
);

Map<String, dynamic> _$$TimelineStepDtoImplToJson(
  _$TimelineStepDtoImpl instance,
) => <String, dynamic>{
  'nodeId': instance.nodeId,
  'stageName': instance.stageName,
  'enabledRole': instance.enabledRole,
  'requirementsToSatisfy': instance.requirementsToSatisfy,
  'completed': instance.completed,
  'active': instance.active,
};
