// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node_status_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RequirementStatus _$RequirementStatusFromJson(Map<String, dynamic> json) {
  return _RequirementStatus.fromJson(json);
}

/// @nodoc
mixin _$RequirementStatus {
  String get requirementName => throw _privateConstructorUsedError;
  bool get satisfied => throw _privateConstructorUsedError;

  /// Serializes this RequirementStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequirementStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequirementStatusCopyWith<RequirementStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequirementStatusCopyWith<$Res> {
  factory $RequirementStatusCopyWith(
    RequirementStatus value,
    $Res Function(RequirementStatus) then,
  ) = _$RequirementStatusCopyWithImpl<$Res, RequirementStatus>;
  @useResult
  $Res call({String requirementName, bool satisfied});
}

/// @nodoc
class _$RequirementStatusCopyWithImpl<$Res, $Val extends RequirementStatus>
    implements $RequirementStatusCopyWith<$Res> {
  _$RequirementStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequirementStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? requirementName = null, Object? satisfied = null}) {
    return _then(
      _value.copyWith(
            requirementName: null == requirementName
                ? _value.requirementName
                : requirementName // ignore: cast_nullable_to_non_nullable
                      as String,
            satisfied: null == satisfied
                ? _value.satisfied
                : satisfied // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RequirementStatusImplCopyWith<$Res>
    implements $RequirementStatusCopyWith<$Res> {
  factory _$$RequirementStatusImplCopyWith(
    _$RequirementStatusImpl value,
    $Res Function(_$RequirementStatusImpl) then,
  ) = __$$RequirementStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String requirementName, bool satisfied});
}

/// @nodoc
class __$$RequirementStatusImplCopyWithImpl<$Res>
    extends _$RequirementStatusCopyWithImpl<$Res, _$RequirementStatusImpl>
    implements _$$RequirementStatusImplCopyWith<$Res> {
  __$$RequirementStatusImplCopyWithImpl(
    _$RequirementStatusImpl _value,
    $Res Function(_$RequirementStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RequirementStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? requirementName = null, Object? satisfied = null}) {
    return _then(
      _$RequirementStatusImpl(
        requirementName: null == requirementName
            ? _value.requirementName
            : requirementName // ignore: cast_nullable_to_non_nullable
                  as String,
        satisfied: null == satisfied
            ? _value.satisfied
            : satisfied // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RequirementStatusImpl implements _RequirementStatus {
  const _$RequirementStatusImpl({
    required this.requirementName,
    required this.satisfied,
  });

  factory _$RequirementStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequirementStatusImplFromJson(json);

  @override
  final String requirementName;
  @override
  final bool satisfied;

  @override
  String toString() {
    return 'RequirementStatus(requirementName: $requirementName, satisfied: $satisfied)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequirementStatusImpl &&
            (identical(other.requirementName, requirementName) ||
                other.requirementName == requirementName) &&
            (identical(other.satisfied, satisfied) ||
                other.satisfied == satisfied));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, requirementName, satisfied);

  /// Create a copy of RequirementStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequirementStatusImplCopyWith<_$RequirementStatusImpl> get copyWith =>
      __$$RequirementStatusImplCopyWithImpl<_$RequirementStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RequirementStatusImplToJson(this);
  }
}

abstract class _RequirementStatus implements RequirementStatus {
  const factory _RequirementStatus({
    required final String requirementName,
    required final bool satisfied,
  }) = _$RequirementStatusImpl;

  factory _RequirementStatus.fromJson(Map<String, dynamic> json) =
      _$RequirementStatusImpl.fromJson;

  @override
  String get requirementName;
  @override
  bool get satisfied;

  /// Create a copy of RequirementStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequirementStatusImplCopyWith<_$RequirementStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
