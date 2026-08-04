// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_status_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequirementStatusImpl _$$RequirementStatusImplFromJson(
  Map<String, dynamic> json,
) => _$RequirementStatusImpl(
  requirementName: json['requirementName'] as String,
  satisfied: json['satisfied'] as bool,
);

Map<String, dynamic> _$$RequirementStatusImplToJson(
  _$RequirementStatusImpl instance,
) => <String, dynamic>{
  'requirementName': instance.requirementName,
  'satisfied': instance.satisfied,
};
