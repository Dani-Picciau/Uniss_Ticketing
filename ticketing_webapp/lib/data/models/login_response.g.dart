// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      token: json['token'] as String,
      userId: json['userId'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      title: json['title'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'userId': instance.userId,
      'roles': instance.roles,
      'title': instance.title,
      'name': instance.name,
      'surname': instance.surname,
    };
