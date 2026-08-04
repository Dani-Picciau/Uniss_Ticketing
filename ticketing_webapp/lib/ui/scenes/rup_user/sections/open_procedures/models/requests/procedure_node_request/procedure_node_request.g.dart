// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procedure_node_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProcedureNodeImpl _$$ProcedureNodeImplFromJson(Map<String, dynamic> json) =>
    _$ProcedureNodeImpl(
      nodeId: json['nodeId'] as String,
      stageName: json['stageName'] as String,
      enabledRole: json['enabledRole'] as String,
      requirementsToSatisfy:
          (json['requirementsToSatisfy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nextNodeIfOk: json['nextNodeIfOk'] as String,
      nextNodeIfSkipped: json['nextNodeIfSkipped'] as String,
      skipCondition: json['skipCondition'] as String?,
    );

Map<String, dynamic> _$$ProcedureNodeImplToJson(_$ProcedureNodeImpl instance) =>
    <String, dynamic>{
      'nodeId': instance.nodeId,
      'stageName': instance.stageName,
      'enabledRole': instance.enabledRole,
      'requirementsToSatisfy': instance.requirementsToSatisfy,
      'nextNodeIfOk': instance.nextNodeIfOk,
      'nextNodeIfSkipped': instance.nextNodeIfSkipped,
      'skipCondition': instance.skipCondition,
    };
