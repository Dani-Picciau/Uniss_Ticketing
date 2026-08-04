// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TimelineDto _$TimelineDtoFromJson(Map<String, dynamic> json) {
  return _TimelineDto.fromJson(json);
}

/// @nodoc
mixin _$TimelineDto {
  String get procedureId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<TimelineStepDto> get steps => throw _privateConstructorUsedError;

  /// Serializes this TimelineDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimelineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimelineDtoCopyWith<TimelineDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineDtoCopyWith<$Res> {
  factory $TimelineDtoCopyWith(
    TimelineDto value,
    $Res Function(TimelineDto) then,
  ) = _$TimelineDtoCopyWithImpl<$Res, TimelineDto>;
  @useResult
  $Res call({
    String procedureId,
    String title,
    String status,
    List<TimelineStepDto> steps,
  });
}

/// @nodoc
class _$TimelineDtoCopyWithImpl<$Res, $Val extends TimelineDto>
    implements $TimelineDtoCopyWith<$Res> {
  _$TimelineDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimelineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? procedureId = null,
    Object? title = null,
    Object? status = null,
    Object? steps = null,
  }) {
    return _then(
      _value.copyWith(
            procedureId: null == procedureId
                ? _value.procedureId
                : procedureId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            steps: null == steps
                ? _value.steps
                : steps // ignore: cast_nullable_to_non_nullable
                      as List<TimelineStepDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimelineDtoImplCopyWith<$Res>
    implements $TimelineDtoCopyWith<$Res> {
  factory _$$TimelineDtoImplCopyWith(
    _$TimelineDtoImpl value,
    $Res Function(_$TimelineDtoImpl) then,
  ) = __$$TimelineDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String procedureId,
    String title,
    String status,
    List<TimelineStepDto> steps,
  });
}

/// @nodoc
class __$$TimelineDtoImplCopyWithImpl<$Res>
    extends _$TimelineDtoCopyWithImpl<$Res, _$TimelineDtoImpl>
    implements _$$TimelineDtoImplCopyWith<$Res> {
  __$$TimelineDtoImplCopyWithImpl(
    _$TimelineDtoImpl _value,
    $Res Function(_$TimelineDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimelineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? procedureId = null,
    Object? title = null,
    Object? status = null,
    Object? steps = null,
  }) {
    return _then(
      _$TimelineDtoImpl(
        procedureId: null == procedureId
            ? _value.procedureId
            : procedureId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        steps: null == steps
            ? _value._steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as List<TimelineStepDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimelineDtoImpl implements _TimelineDto {
  const _$TimelineDtoImpl({
    required this.procedureId,
    required this.title,
    required this.status,
    final List<TimelineStepDto> steps = const [],
  }) : _steps = steps;

  factory _$TimelineDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimelineDtoImplFromJson(json);

  @override
  final String procedureId;
  @override
  final String title;
  @override
  final String status;
  final List<TimelineStepDto> _steps;
  @override
  @JsonKey()
  List<TimelineStepDto> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  String toString() {
    return 'TimelineDto(procedureId: $procedureId, title: $title, status: $status, steps: $steps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelineDtoImpl &&
            (identical(other.procedureId, procedureId) ||
                other.procedureId == procedureId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._steps, _steps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    procedureId,
    title,
    status,
    const DeepCollectionEquality().hash(_steps),
  );

  /// Create a copy of TimelineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelineDtoImplCopyWith<_$TimelineDtoImpl> get copyWith =>
      __$$TimelineDtoImplCopyWithImpl<_$TimelineDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimelineDtoImplToJson(this);
  }
}

abstract class _TimelineDto implements TimelineDto {
  const factory _TimelineDto({
    required final String procedureId,
    required final String title,
    required final String status,
    final List<TimelineStepDto> steps,
  }) = _$TimelineDtoImpl;

  factory _TimelineDto.fromJson(Map<String, dynamic> json) =
      _$TimelineDtoImpl.fromJson;

  @override
  String get procedureId;
  @override
  String get title;
  @override
  String get status;
  @override
  List<TimelineStepDto> get steps;

  /// Create a copy of TimelineDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimelineDtoImplCopyWith<_$TimelineDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimelineStepDto _$TimelineStepDtoFromJson(Map<String, dynamic> json) {
  return _TimelineStepDto.fromJson(json);
}

/// @nodoc
mixin _$TimelineStepDto {
  String get nodeId => throw _privateConstructorUsedError;
  String get stageName => throw _privateConstructorUsedError;
  String? get enabledRole => throw _privateConstructorUsedError;
  List<String> get requirementsToSatisfy => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;

  /// Serializes this TimelineStepDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimelineStepDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimelineStepDtoCopyWith<TimelineStepDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineStepDtoCopyWith<$Res> {
  factory $TimelineStepDtoCopyWith(
    TimelineStepDto value,
    $Res Function(TimelineStepDto) then,
  ) = _$TimelineStepDtoCopyWithImpl<$Res, TimelineStepDto>;
  @useResult
  $Res call({
    String nodeId,
    String stageName,
    String? enabledRole,
    List<String> requirementsToSatisfy,
    bool completed,
    bool active,
  });
}

/// @nodoc
class _$TimelineStepDtoCopyWithImpl<$Res, $Val extends TimelineStepDto>
    implements $TimelineStepDtoCopyWith<$Res> {
  _$TimelineStepDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimelineStepDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodeId = null,
    Object? stageName = null,
    Object? enabledRole = freezed,
    Object? requirementsToSatisfy = null,
    Object? completed = null,
    Object? active = null,
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
            enabledRole: freezed == enabledRole
                ? _value.enabledRole
                : enabledRole // ignore: cast_nullable_to_non_nullable
                      as String?,
            requirementsToSatisfy: null == requirementsToSatisfy
                ? _value.requirementsToSatisfy
                : requirementsToSatisfy // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
            active: null == active
                ? _value.active
                : active // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimelineStepDtoImplCopyWith<$Res>
    implements $TimelineStepDtoCopyWith<$Res> {
  factory _$$TimelineStepDtoImplCopyWith(
    _$TimelineStepDtoImpl value,
    $Res Function(_$TimelineStepDtoImpl) then,
  ) = __$$TimelineStepDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String nodeId,
    String stageName,
    String? enabledRole,
    List<String> requirementsToSatisfy,
    bool completed,
    bool active,
  });
}

/// @nodoc
class __$$TimelineStepDtoImplCopyWithImpl<$Res>
    extends _$TimelineStepDtoCopyWithImpl<$Res, _$TimelineStepDtoImpl>
    implements _$$TimelineStepDtoImplCopyWith<$Res> {
  __$$TimelineStepDtoImplCopyWithImpl(
    _$TimelineStepDtoImpl _value,
    $Res Function(_$TimelineStepDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimelineStepDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodeId = null,
    Object? stageName = null,
    Object? enabledRole = freezed,
    Object? requirementsToSatisfy = null,
    Object? completed = null,
    Object? active = null,
  }) {
    return _then(
      _$TimelineStepDtoImpl(
        nodeId: null == nodeId
            ? _value.nodeId
            : nodeId // ignore: cast_nullable_to_non_nullable
                  as String,
        stageName: null == stageName
            ? _value.stageName
            : stageName // ignore: cast_nullable_to_non_nullable
                  as String,
        enabledRole: freezed == enabledRole
            ? _value.enabledRole
            : enabledRole // ignore: cast_nullable_to_non_nullable
                  as String?,
        requirementsToSatisfy: null == requirementsToSatisfy
            ? _value._requirementsToSatisfy
            : requirementsToSatisfy // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
        active: null == active
            ? _value.active
            : active // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimelineStepDtoImpl implements _TimelineStepDto {
  const _$TimelineStepDtoImpl({
    required this.nodeId,
    required this.stageName,
    this.enabledRole,
    final List<String> requirementsToSatisfy = const [],
    required this.completed,
    required this.active,
  }) : _requirementsToSatisfy = requirementsToSatisfy;

  factory _$TimelineStepDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimelineStepDtoImplFromJson(json);

  @override
  final String nodeId;
  @override
  final String stageName;
  @override
  final String? enabledRole;
  final List<String> _requirementsToSatisfy;
  @override
  @JsonKey()
  List<String> get requirementsToSatisfy {
    if (_requirementsToSatisfy is EqualUnmodifiableListView)
      return _requirementsToSatisfy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requirementsToSatisfy);
  }

  @override
  final bool completed;
  @override
  final bool active;

  @override
  String toString() {
    return 'TimelineStepDto(nodeId: $nodeId, stageName: $stageName, enabledRole: $enabledRole, requirementsToSatisfy: $requirementsToSatisfy, completed: $completed, active: $active)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelineStepDtoImpl &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.stageName, stageName) ||
                other.stageName == stageName) &&
            (identical(other.enabledRole, enabledRole) ||
                other.enabledRole == enabledRole) &&
            const DeepCollectionEquality().equals(
              other._requirementsToSatisfy,
              _requirementsToSatisfy,
            ) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    nodeId,
    stageName,
    enabledRole,
    const DeepCollectionEquality().hash(_requirementsToSatisfy),
    completed,
    active,
  );

  /// Create a copy of TimelineStepDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelineStepDtoImplCopyWith<_$TimelineStepDtoImpl> get copyWith =>
      __$$TimelineStepDtoImplCopyWithImpl<_$TimelineStepDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TimelineStepDtoImplToJson(this);
  }
}

abstract class _TimelineStepDto implements TimelineStepDto {
  const factory _TimelineStepDto({
    required final String nodeId,
    required final String stageName,
    final String? enabledRole,
    final List<String> requirementsToSatisfy,
    required final bool completed,
    required final bool active,
  }) = _$TimelineStepDtoImpl;

  factory _TimelineStepDto.fromJson(Map<String, dynamic> json) =
      _$TimelineStepDtoImpl.fromJson;

  @override
  String get nodeId;
  @override
  String get stageName;
  @override
  String? get enabledRole;
  @override
  List<String> get requirementsToSatisfy;
  @override
  bool get completed;
  @override
  bool get active;

  /// Create a copy of TimelineStepDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimelineStepDtoImplCopyWith<_$TimelineStepDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
