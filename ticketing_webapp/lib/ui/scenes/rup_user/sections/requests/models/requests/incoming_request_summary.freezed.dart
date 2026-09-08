// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incoming_request_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

IncomingRequestSummary _$IncomingRequestSummaryFromJson(
  Map<String, dynamic> json,
) {
  return _IncomingRequestSummary.fromJson(json);
}

/// @nodoc
mixin _$IncomingRequestSummary {
  String get id => throw _privateConstructorUsedError;
  String get requestingProfessorName => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get linkedProcedureId => throw _privateConstructorUsedError;

  /// Serializes this IncomingRequestSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IncomingRequestSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomingRequestSummaryCopyWith<IncomingRequestSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomingRequestSummaryCopyWith<$Res> {
  factory $IncomingRequestSummaryCopyWith(
    IncomingRequestSummary value,
    $Res Function(IncomingRequestSummary) then,
  ) = _$IncomingRequestSummaryCopyWithImpl<$Res, IncomingRequestSummary>;
  @useResult
  $Res call({
    String id,
    String requestingProfessorName,
    String subject,
    String content,
    String status,
    DateTime createdAt,
    String? linkedProcedureId,
  });
}

/// @nodoc
class _$IncomingRequestSummaryCopyWithImpl<
  $Res,
  $Val extends IncomingRequestSummary
>
    implements $IncomingRequestSummaryCopyWith<$Res> {
  _$IncomingRequestSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomingRequestSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestingProfessorName = null,
    Object? subject = null,
    Object? content = null,
    Object? status = null,
    Object? createdAt = null,
    Object? linkedProcedureId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            requestingProfessorName: null == requestingProfessorName
                ? _value.requestingProfessorName
                : requestingProfessorName // ignore: cast_nullable_to_non_nullable
                      as String,
            subject: null == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            linkedProcedureId: freezed == linkedProcedureId
                ? _value.linkedProcedureId
                : linkedProcedureId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IncomingRequestSummaryImplCopyWith<$Res>
    implements $IncomingRequestSummaryCopyWith<$Res> {
  factory _$$IncomingRequestSummaryImplCopyWith(
    _$IncomingRequestSummaryImpl value,
    $Res Function(_$IncomingRequestSummaryImpl) then,
  ) = __$$IncomingRequestSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String requestingProfessorName,
    String subject,
    String content,
    String status,
    DateTime createdAt,
    String? linkedProcedureId,
  });
}

/// @nodoc
class __$$IncomingRequestSummaryImplCopyWithImpl<$Res>
    extends
        _$IncomingRequestSummaryCopyWithImpl<$Res, _$IncomingRequestSummaryImpl>
    implements _$$IncomingRequestSummaryImplCopyWith<$Res> {
  __$$IncomingRequestSummaryImplCopyWithImpl(
    _$IncomingRequestSummaryImpl _value,
    $Res Function(_$IncomingRequestSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IncomingRequestSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestingProfessorName = null,
    Object? subject = null,
    Object? content = null,
    Object? status = null,
    Object? createdAt = null,
    Object? linkedProcedureId = freezed,
  }) {
    return _then(
      _$IncomingRequestSummaryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        requestingProfessorName: null == requestingProfessorName
            ? _value.requestingProfessorName
            : requestingProfessorName // ignore: cast_nullable_to_non_nullable
                  as String,
        subject: null == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        linkedProcedureId: freezed == linkedProcedureId
            ? _value.linkedProcedureId
            : linkedProcedureId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IncomingRequestSummaryImpl implements _IncomingRequestSummary {
  const _$IncomingRequestSummaryImpl({
    required this.id,
    required this.requestingProfessorName,
    required this.subject,
    required this.content,
    required this.status,
    required this.createdAt,
    this.linkedProcedureId,
  });

  factory _$IncomingRequestSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncomingRequestSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String requestingProfessorName;
  @override
  final String subject;
  @override
  final String content;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final String? linkedProcedureId;

  @override
  String toString() {
    return 'IncomingRequestSummary(id: $id, requestingProfessorName: $requestingProfessorName, subject: $subject, content: $content, status: $status, createdAt: $createdAt, linkedProcedureId: $linkedProcedureId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomingRequestSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(
                  other.requestingProfessorName,
                  requestingProfessorName,
                ) ||
                other.requestingProfessorName == requestingProfessorName) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.linkedProcedureId, linkedProcedureId) ||
                other.linkedProcedureId == linkedProcedureId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    requestingProfessorName,
    subject,
    content,
    status,
    createdAt,
    linkedProcedureId,
  );

  /// Create a copy of IncomingRequestSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomingRequestSummaryImplCopyWith<_$IncomingRequestSummaryImpl>
  get copyWith =>
      __$$IncomingRequestSummaryImplCopyWithImpl<_$IncomingRequestSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$IncomingRequestSummaryImplToJson(this);
  }
}

abstract class _IncomingRequestSummary implements IncomingRequestSummary {
  const factory _IncomingRequestSummary({
    required final String id,
    required final String requestingProfessorName,
    required final String subject,
    required final String content,
    required final String status,
    required final DateTime createdAt,
    final String? linkedProcedureId,
  }) = _$IncomingRequestSummaryImpl;

  factory _IncomingRequestSummary.fromJson(Map<String, dynamic> json) =
      _$IncomingRequestSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get requestingProfessorName;
  @override
  String get subject;
  @override
  String get content;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  String? get linkedProcedureId;

  /// Create a copy of IncomingRequestSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomingRequestSummaryImplCopyWith<_$IncomingRequestSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}
