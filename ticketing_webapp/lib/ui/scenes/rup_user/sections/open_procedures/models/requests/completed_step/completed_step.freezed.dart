// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'completed_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CompletedStep _$CompletedStepFromJson(Map<String, dynamic> json) {
  return _CompletedStep.fromJson(json);
}

/// @nodoc
mixin _$CompletedStep {
  String get nodeId => throw _privateConstructorUsedError;
  String get stageName => throw _privateConstructorUsedError;
  String get completedByUserId => throw _privateConstructorUsedError;
  DateTime get completedAt => throw _privateConstructorUsedError;
  List<RequirementStatus> get requirementsAtCompletion =>
      throw _privateConstructorUsedError;

  /// Serializes this CompletedStep to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompletedStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompletedStepCopyWith<CompletedStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletedStepCopyWith<$Res> {
  factory $CompletedStepCopyWith(
    CompletedStep value,
    $Res Function(CompletedStep) then,
  ) = _$CompletedStepCopyWithImpl<$Res, CompletedStep>;
  @useResult
  $Res call({
    String nodeId,
    String stageName,
    String completedByUserId,
    DateTime completedAt,
    List<RequirementStatus> requirementsAtCompletion,
  });
}

/// @nodoc
class _$CompletedStepCopyWithImpl<$Res, $Val extends CompletedStep>
    implements $CompletedStepCopyWith<$Res> {
  _$CompletedStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompletedStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodeId = null,
    Object? stageName = null,
    Object? completedByUserId = null,
    Object? completedAt = null,
    Object? requirementsAtCompletion = null,
  }) {
    return _then(
      _value.copyWith(
            nodeId: null == nodeId
                ? _value.nodeId
                : nodeId // ignore: cast_nullable_to_non_nullable
                      as String,
            stageName: null == stageName
                ? _value.stageName
                : stageName // ignore: cast_nullable_to_non_nullable
                      as String,
            completedByUserId: null == completedByUserId
                ? _value.completedByUserId
                : completedByUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            completedAt: null == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            requirementsAtCompletion: null == requirementsAtCompletion
                ? _value.requirementsAtCompletion
                : requirementsAtCompletion // ignore: cast_nullable_to_non_nullable
                      as List<RequirementStatus>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompletedStepImplCopyWith<$Res>
    implements $CompletedStepCopyWith<$Res> {
  factory _$$CompletedStepImplCopyWith(
    _$CompletedStepImpl value,
    $Res Function(_$CompletedStepImpl) then,
  ) = __$$CompletedStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String nodeId,
    String stageName,
    String completedByUserId,
    DateTime completedAt,
    List<RequirementStatus> requirementsAtCompletion,
  });
}

/// @nodoc
class __$$CompletedStepImplCopyWithImpl<$Res>
    extends _$CompletedStepCopyWithImpl<$Res, _$CompletedStepImpl>
    implements _$$CompletedStepImplCopyWith<$Res> {
  __$$CompletedStepImplCopyWithImpl(
    _$CompletedStepImpl _value,
    $Res Function(_$CompletedStepImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompletedStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodeId = null,
    Object? stageName = null,
    Object? completedByUserId = null,
    Object? completedAt = null,
    Object? requirementsAtCompletion = null,
  }) {
    return _then(
      _$CompletedStepImpl(
        nodeId: null == nodeId
            ? _value.nodeId
            : nodeId // ignore: cast_nullable_to_non_nullable
                  as String,
        stageName: null == stageName
            ? _value.stageName
            : stageName // ignore: cast_nullable_to_non_nullable
                  as String,
        completedByUserId: null == completedByUserId
            ? _value.completedByUserId
            : completedByUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        completedAt: null == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        requirementsAtCompletion: null == requirementsAtCompletion
            ? _value._requirementsAtCompletion
            : requirementsAtCompletion // ignore: cast_nullable_to_non_nullable
                  as List<RequirementStatus>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompletedStepImpl implements _CompletedStep {
  const _$CompletedStepImpl({
    required this.nodeId,
    required this.stageName,
    required this.completedByUserId,
    required this.completedAt,
    final List<RequirementStatus> requirementsAtCompletion = const [],
  }) : _requirementsAtCompletion = requirementsAtCompletion;

  factory _$CompletedStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompletedStepImplFromJson(json);

  @override
  final String nodeId;
  @override
  final String stageName;
  @override
  final String completedByUserId;
  @override
  final DateTime completedAt;
  final List<RequirementStatus> _requirementsAtCompletion;
  @override
  @JsonKey()
  List<RequirementStatus> get requirementsAtCompletion {
    if (_requirementsAtCompletion is EqualUnmodifiableListView)
      return _requirementsAtCompletion;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requirementsAtCompletion);
  }

  @override
  String toString() {
    return 'CompletedStep(nodeId: $nodeId, stageName: $stageName, completedByUserId: $completedByUserId, completedAt: $completedAt, requirementsAtCompletion: $requirementsAtCompletion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletedStepImpl &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.stageName, stageName) ||
                other.stageName == stageName) &&
            (identical(other.completedByUserId, completedByUserId) ||
                other.completedByUserId == completedByUserId) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality().equals(
              other._requirementsAtCompletion,
              _requirementsAtCompletion,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    nodeId,
    stageName,
    completedByUserId,
    completedAt,
    const DeepCollectionEquality().hash(_requirementsAtCompletion),
  );

  /// Create a copy of CompletedStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletedStepImplCopyWith<_$CompletedStepImpl> get copyWith =>
      __$$CompletedStepImplCopyWithImpl<_$CompletedStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompletedStepImplToJson(this);
  }
}

abstract class _CompletedStep implements CompletedStep {
  const factory _CompletedStep({
    required final String nodeId,
    required final String stageName,
    required final String completedByUserId,
    required final DateTime completedAt,
    final List<RequirementStatus> requirementsAtCompletion,
  }) = _$CompletedStepImpl;

  factory _CompletedStep.fromJson(Map<String, dynamic> json) =
      _$CompletedStepImpl.fromJson;

  @override
  String get nodeId;
  @override
  String get stageName;
  @override
  String get completedByUserId;
  @override
  DateTime get completedAt;
  @override
  List<RequirementStatus> get requirementsAtCompletion;

  /// Create a copy of CompletedStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompletedStepImplCopyWith<_$CompletedStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
