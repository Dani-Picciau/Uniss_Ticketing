// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'professor_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProfessorRequest _$ProfessorRequestFromJson(Map<String, dynamic> json) {
  return _ProfessorRequest.fromJson(json);
}

/// @nodoc
mixin _$ProfessorRequest {
  String get subject => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  /// Serializes this ProfessorRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfessorRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfessorRequestCopyWith<ProfessorRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfessorRequestCopyWith<$Res> {
  factory $ProfessorRequestCopyWith(
    ProfessorRequest value,
    $Res Function(ProfessorRequest) then,
  ) = _$ProfessorRequestCopyWithImpl<$Res, ProfessorRequest>;
  @useResult
  $Res call({String subject, String content});
}

/// @nodoc
class _$ProfessorRequestCopyWithImpl<$Res, $Val extends ProfessorRequest>
    implements $ProfessorRequestCopyWith<$Res> {
  _$ProfessorRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfessorRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? subject = null, Object? content = null}) {
    return _then(
      _value.copyWith(
            subject: null == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfessorRequestImplCopyWith<$Res>
    implements $ProfessorRequestCopyWith<$Res> {
  factory _$$ProfessorRequestImplCopyWith(
    _$ProfessorRequestImpl value,
    $Res Function(_$ProfessorRequestImpl) then,
  ) = __$$ProfessorRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String subject, String content});
}

/// @nodoc
class __$$ProfessorRequestImplCopyWithImpl<$Res>
    extends _$ProfessorRequestCopyWithImpl<$Res, _$ProfessorRequestImpl>
    implements _$$ProfessorRequestImplCopyWith<$Res> {
  __$$ProfessorRequestImplCopyWithImpl(
    _$ProfessorRequestImpl _value,
    $Res Function(_$ProfessorRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfessorRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? subject = null, Object? content = null}) {
    return _then(
      _$ProfessorRequestImpl(
        subject: null == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfessorRequestImpl implements _ProfessorRequest {
  const _$ProfessorRequestImpl({required this.subject, required this.content});

  factory _$ProfessorRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfessorRequestImplFromJson(json);

  @override
  final String subject;
  @override
  final String content;

  @override
  String toString() {
    return 'ProfessorRequest(subject: $subject, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfessorRequestImpl &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, subject, content);

  /// Create a copy of ProfessorRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfessorRequestImplCopyWith<_$ProfessorRequestImpl> get copyWith =>
      __$$ProfessorRequestImplCopyWithImpl<_$ProfessorRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfessorRequestImplToJson(this);
  }
}

abstract class _ProfessorRequest implements ProfessorRequest {
  const factory _ProfessorRequest({
    required final String subject,
    required final String content,
  }) = _$ProfessorRequestImpl;

  factory _ProfessorRequest.fromJson(Map<String, dynamic> json) =
      _$ProfessorRequestImpl.fromJson;

  @override
  String get subject;
  @override
  String get content;

  /// Create a copy of ProfessorRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfessorRequestImplCopyWith<_$ProfessorRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
