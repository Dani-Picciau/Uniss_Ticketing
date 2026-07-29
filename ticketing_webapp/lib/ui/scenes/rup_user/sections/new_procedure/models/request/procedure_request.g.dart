// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procedure_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProcedureRequestImpl _$$ProcedureRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ProcedureRequestImpl(
  procedureType: json['procedureType'] as String,
  title: json['title'] as String,
  amount: (json['amount'] as num).toDouble(),
  requestingProfessorId: json['requestingProfessorId'] as String,
  assignedRupId: json['assignedRupId'] as String,
  assignedAdministratorId: json['assignedAdministratorId'] as String,
  deadline: json['deadline'] as String,
);

Map<String, dynamic> _$$ProcedureRequestImplToJson(
  _$ProcedureRequestImpl instance,
) => <String, dynamic>{
  'procedureType': instance.procedureType,
  'title': instance.title,
  'amount': instance.amount,
  'requestingProfessorId': instance.requestingProfessorId,
  'assignedRupId': instance.assignedRupId,
  'assignedAdministratorId': instance.assignedAdministratorId,
  'deadline': instance.deadline,
};
