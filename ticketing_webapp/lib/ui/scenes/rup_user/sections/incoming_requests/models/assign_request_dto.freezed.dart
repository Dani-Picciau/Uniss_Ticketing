// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assign_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AssignRequestDto _$AssignRequestDtoFromJson(Map<String, dynamic> json) {
  return _AssignRequestDto.fromJson(json);
}

/// @nodoc
mixin _$AssignRequestDto {
  String get administratorId => throw _privateConstructorUsedError;

  /// Serializes this AssignRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssignRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssignRequestDtoCopyWith<AssignRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignRequestDtoCopyWith<$Res> {
  factory $AssignRequestDtoCopyWith(
    AssignRequestDto value,
    $Res Function(AssignRequestDto) then,
  ) = _$AssignRequestDtoCopyWithImpl<$Res, AssignRequestDto>;
  @useResult
  $Res call({String administratorId});
}

/// @nodoc
class _$AssignRequestDtoCopyWithImpl<$Res, $Val extends AssignRequestDto>
    implements $AssignRequestDtoCopyWith<$Res> {
  _$AssignRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssignRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? administratorId = null}) {
    return _then(
      _value.copyWith(
            administratorId: null == administratorId
                ? _value.administratorId
                : administratorId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AssignRequestDtoImplCopyWith<$Res>
    implements $AssignRequestDtoCopyWith<$Res> {
  factory _$$AssignRequestDtoImplCopyWith(
    _$AssignRequestDtoImpl value,
    $Res Function(_$AssignRequestDtoImpl) then,
  ) = __$$AssignRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String administratorId});
}

/// @nodoc
class __$$AssignRequestDtoImplCopyWithImpl<$Res>
    extends _$AssignRequestDtoCopyWithImpl<$Res, _$AssignRequestDtoImpl>
    implements _$$AssignRequestDtoImplCopyWith<$Res> {
  __$$AssignRequestDtoImplCopyWithImpl(
    _$AssignRequestDtoImpl _value,
    $Res Function(_$AssignRequestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssignRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? administratorId = null}) {
    return _then(
      _$AssignRequestDtoImpl(
        administratorId: null == administratorId
            ? _value.administratorId
            : administratorId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AssignRequestDtoImpl implements _AssignRequestDto {
  const _$AssignRequestDtoImpl({required this.administratorId});

  factory _$AssignRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssignRequestDtoImplFromJson(json);

  @override
  final String administratorId;

  @override
  String toString() {
    return 'AssignRequestDto(administratorId: $administratorId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssignRequestDtoImpl &&
            (identical(other.administratorId, administratorId) ||
                other.administratorId == administratorId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, administratorId);

  /// Create a copy of AssignRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssignRequestDtoImplCopyWith<_$AssignRequestDtoImpl> get copyWith =>
      __$$AssignRequestDtoImplCopyWithImpl<_$AssignRequestDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AssignRequestDtoImplToJson(this);
  }
}

abstract class _AssignRequestDto implements AssignRequestDto {
  const factory _AssignRequestDto({required final String administratorId}) =
      _$AssignRequestDtoImpl;

  factory _AssignRequestDto.fromJson(Map<String, dynamic> json) =
      _$AssignRequestDtoImpl.fromJson;

  @override
  String get administratorId;

  /// Create a copy of AssignRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssignRequestDtoImplCopyWith<_$AssignRequestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
