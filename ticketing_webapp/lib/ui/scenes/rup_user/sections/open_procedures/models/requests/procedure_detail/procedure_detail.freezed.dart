// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'procedure_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProcedureDetail _$ProcedureDetailFromJson(Map<String, dynamic> json) {
  return _ProcedureDetail.fromJson(json);
}

/// @nodoc
mixin _$ProcedureDetail {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get procedureType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get currentNodeId => throw _privateConstructorUsedError;
  String get currentEnabledRole => throw _privateConstructorUsedError;
  List<RequirementStatus> get currentRequirementsStatus =>
      throw _privateConstructorUsedError;
  List<CompletedStep> get completedSteps => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get deadline => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;

  /// Serializes this ProcedureDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProcedureDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProcedureDetailCopyWith<ProcedureDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProcedureDetailCopyWith<$Res> {
  factory $ProcedureDetailCopyWith(
    ProcedureDetail value,
    $Res Function(ProcedureDetail) then,
  ) = _$ProcedureDetailCopyWithImpl<$Res, ProcedureDetail>;
  @useResult
  $Res call({
    String id,
    String title,
    String procedureType,
    String status,
    String currentNodeId,
    String currentEnabledRole,
    List<RequirementStatus> currentRequirementsStatus,
    List<CompletedStep> completedSteps,
    DateTime createdAt,
    DateTime? deadline,
    int? duration,
  });
}

/// @nodoc
class _$ProcedureDetailCopyWithImpl<$Res, $Val extends ProcedureDetail>
    implements $ProcedureDetailCopyWith<$Res> {
  _$ProcedureDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProcedureDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? procedureType = null,
    Object? status = null,
    Object? currentNodeId = null,
    Object? currentEnabledRole = null,
    Object? currentRequirementsStatus = null,
    Object? completedSteps = null,
    Object? createdAt = null,
    Object? deadline = freezed,
    Object? duration = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            procedureType: null == procedureType
                ? _value.procedureType
                : procedureType // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            currentNodeId: null == currentNodeId
                ? _value.currentNodeId
                : currentNodeId // ignore: cast_nullable_to_non_nullable
                      as String,
            currentEnabledRole: null == currentEnabledRole
                ? _value.currentEnabledRole
                : currentEnabledRole // ignore: cast_nullable_to_non_nullable
                      as String,
            currentRequirementsStatus: null == currentRequirementsStatus
                ? _value.currentRequirementsStatus
                : currentRequirementsStatus // ignore: cast_nullable_to_non_nullable
                      as List<RequirementStatus>,
            completedSteps: null == completedSteps
                ? _value.completedSteps
                : completedSteps // ignore: cast_nullable_to_non_nullable
                      as List<CompletedStep>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            deadline: freezed == deadline
                ? _value.deadline
                : deadline // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProcedureDetailImplCopyWith<$Res>
    implements $ProcedureDetailCopyWith<$Res> {
  factory _$$ProcedureDetailImplCopyWith(
    _$ProcedureDetailImpl value,
    $Res Function(_$ProcedureDetailImpl) then,
  ) = __$$ProcedureDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String procedureType,
    String status,
    String currentNodeId,
    String currentEnabledRole,
    List<RequirementStatus> currentRequirementsStatus,
    List<CompletedStep> completedSteps,
    DateTime createdAt,
    DateTime? deadline,
    int? duration,
  });
}

/// @nodoc
class __$$ProcedureDetailImplCopyWithImpl<$Res>
    extends _$ProcedureDetailCopyWithImpl<$Res, _$ProcedureDetailImpl>
    implements _$$ProcedureDetailImplCopyWith<$Res> {
  __$$ProcedureDetailImplCopyWithImpl(
    _$ProcedureDetailImpl _value,
    $Res Function(_$ProcedureDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProcedureDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? procedureType = null,
    Object? status = null,
    Object? currentNodeId = null,
    Object? currentEnabledRole = null,
    Object? currentRequirementsStatus = null,
    Object? completedSteps = null,
    Object? createdAt = null,
    Object? deadline = freezed,
    Object? duration = freezed,
  }) {
    return _then(
      _$ProcedureDetailImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        procedureType: null == procedureType
            ? _value.procedureType
            : procedureType // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        currentNodeId: null == currentNodeId
            ? _value.currentNodeId
            : currentNodeId // ignore: cast_nullable_to_non_nullable
                  as String,
        currentEnabledRole: null == currentEnabledRole
            ? _value.currentEnabledRole
            : currentEnabledRole // ignore: cast_nullable_to_non_nullable
                  as String,
        currentRequirementsStatus: null == currentRequirementsStatus
            ? _value._currentRequirementsStatus
            : currentRequirementsStatus // ignore: cast_nullable_to_non_nullable
                  as List<RequirementStatus>,
        completedSteps: null == completedSteps
            ? _value._completedSteps
            : completedSteps // ignore: cast_nullable_to_non_nullable
                  as List<CompletedStep>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deadline: freezed == deadline
            ? _value.deadline
            : deadline // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProcedureDetailImpl implements _ProcedureDetail {
  const _$ProcedureDetailImpl({
    required this.id,
    required this.title,
    required this.procedureType,
    required this.status,
    required this.currentNodeId,
    required this.currentEnabledRole,
    final List<RequirementStatus> currentRequirementsStatus = const [],
    final List<CompletedStep> completedSteps = const [],
    required this.createdAt,
    this.deadline,
    this.duration,
  }) : _currentRequirementsStatus = currentRequirementsStatus,
       _completedSteps = completedSteps;

  factory _$ProcedureDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProcedureDetailImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String procedureType;
  @override
  final String status;
  @override
  final String currentNodeId;
  @override
  final String currentEnabledRole;
  final List<RequirementStatus> _currentRequirementsStatus;
  @override
  @JsonKey()
  List<RequirementStatus> get currentRequirementsStatus {
    if (_currentRequirementsStatus is EqualUnmodifiableListView)
      return _currentRequirementsStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentRequirementsStatus);
  }

  final List<CompletedStep> _completedSteps;
  @override
  @JsonKey()
  List<CompletedStep> get completedSteps {
    if (_completedSteps is EqualUnmodifiableListView) return _completedSteps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedSteps);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? deadline;
  @override
  final int? duration;

  @override
  String toString() {
    return 'ProcedureDetail(id: $id, title: $title, procedureType: $procedureType, status: $status, currentNodeId: $currentNodeId, currentEnabledRole: $currentEnabledRole, currentRequirementsStatus: $currentRequirementsStatus, completedSteps: $completedSteps, createdAt: $createdAt, deadline: $deadline, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProcedureDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.procedureType, procedureType) ||
                other.procedureType == procedureType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentNodeId, currentNodeId) ||
                other.currentNodeId == currentNodeId) &&
            (identical(other.currentEnabledRole, currentEnabledRole) ||
                other.currentEnabledRole == currentEnabledRole) &&
            const DeepCollectionEquality().equals(
              other._currentRequirementsStatus,
              _currentRequirementsStatus,
            ) &&
            const DeepCollectionEquality().equals(
              other._completedSteps,
              _completedSteps,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    procedureType,
    status,
    currentNodeId,
    currentEnabledRole,
    const DeepCollectionEquality().hash(_currentRequirementsStatus),
    const DeepCollectionEquality().hash(_completedSteps),
    createdAt,
    deadline,
    duration,
  );

  /// Create a copy of ProcedureDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProcedureDetailImplCopyWith<_$ProcedureDetailImpl> get copyWith =>
      __$$ProcedureDetailImplCopyWithImpl<_$ProcedureDetailImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProcedureDetailImplToJson(this);
  }
}

abstract class _ProcedureDetail implements ProcedureDetail {
  const factory _ProcedureDetail({
    required final String id,
    required final String title,
    required final String procedureType,
    required final String status,
    required final String currentNodeId,
    required final String currentEnabledRole,
    final List<RequirementStatus> currentRequirementsStatus,
    final List<CompletedStep> completedSteps,
    required final DateTime createdAt,
    final DateTime? deadline,
    final int? duration,
  }) = _$ProcedureDetailImpl;

  factory _ProcedureDetail.fromJson(Map<String, dynamic> json) =
      _$ProcedureDetailImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get procedureType;
  @override
  String get status;
  @override
  String get currentNodeId;
  @override
  String get currentEnabledRole;
  @override
  List<RequirementStatus> get currentRequirementsStatus;
  @override
  List<CompletedStep> get completedSteps;
  @override
  DateTime get createdAt;
  @override
  DateTime? get deadline;
  @override
  int? get duration;

  /// Create a copy of ProcedureDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProcedureDetailImplCopyWith<_$ProcedureDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
