// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'procedure_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProcedureSummary _$ProcedureSummaryFromJson(Map<String, dynamic> json) {
  return _ProcedureSummary.fromJson(json);
}

/// @nodoc
mixin _$ProcedureSummary {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get procedureType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get currentNodeId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get deadline => throw _privateConstructorUsedError;

  /// Serializes this ProcedureSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProcedureSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProcedureSummaryCopyWith<ProcedureSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProcedureSummaryCopyWith<$Res> {
  factory $ProcedureSummaryCopyWith(
    ProcedureSummary value,
    $Res Function(ProcedureSummary) then,
  ) = _$ProcedureSummaryCopyWithImpl<$Res, ProcedureSummary>;
  @useResult
  $Res call({
    String id,
    String title,
    String procedureType,
    String status,
    String currentNodeId,
    DateTime createdAt,
    DateTime? deadline,
  });
}

/// @nodoc
class _$ProcedureSummaryCopyWithImpl<$Res, $Val extends ProcedureSummary>
    implements $ProcedureSummaryCopyWith<$Res> {
  _$ProcedureSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProcedureSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? procedureType = null,
    Object? status = null,
    Object? currentNodeId = null,
    Object? createdAt = null,
    Object? deadline = freezed,
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
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            deadline: freezed == deadline
                ? _value.deadline
                : deadline // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProcedureSummaryImplCopyWith<$Res>
    implements $ProcedureSummaryCopyWith<$Res> {
  factory _$$ProcedureSummaryImplCopyWith(
    _$ProcedureSummaryImpl value,
    $Res Function(_$ProcedureSummaryImpl) then,
  ) = __$$ProcedureSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String procedureType,
    String status,
    String currentNodeId,
    DateTime createdAt,
    DateTime? deadline,
  });
}

/// @nodoc
class __$$ProcedureSummaryImplCopyWithImpl<$Res>
    extends _$ProcedureSummaryCopyWithImpl<$Res, _$ProcedureSummaryImpl>
    implements _$$ProcedureSummaryImplCopyWith<$Res> {
  __$$ProcedureSummaryImplCopyWithImpl(
    _$ProcedureSummaryImpl _value,
    $Res Function(_$ProcedureSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProcedureSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? procedureType = null,
    Object? status = null,
    Object? currentNodeId = null,
    Object? createdAt = null,
    Object? deadline = freezed,
  }) {
    return _then(
      _$ProcedureSummaryImpl(
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
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deadline: freezed == deadline
            ? _value.deadline
            : deadline // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProcedureSummaryImpl implements _ProcedureSummary {
  const _$ProcedureSummaryImpl({
    required this.id,
    required this.title,
    required this.procedureType,
    required this.status,
    required this.currentNodeId,
    required this.createdAt,
    this.deadline,
  });

  factory _$ProcedureSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProcedureSummaryImplFromJson(json);

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
  final DateTime createdAt;
  @override
  final DateTime? deadline;

  @override
  String toString() {
    return 'ProcedureSummary(id: $id, title: $title, procedureType: $procedureType, status: $status, currentNodeId: $currentNodeId, createdAt: $createdAt, deadline: $deadline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProcedureSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.procedureType, procedureType) ||
                other.procedureType == procedureType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentNodeId, currentNodeId) ||
                other.currentNodeId == currentNodeId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline));
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
    createdAt,
    deadline,
  );

  /// Create a copy of ProcedureSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProcedureSummaryImplCopyWith<_$ProcedureSummaryImpl> get copyWith =>
      __$$ProcedureSummaryImplCopyWithImpl<_$ProcedureSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProcedureSummaryImplToJson(this);
  }
}

abstract class _ProcedureSummary implements ProcedureSummary {
  const factory _ProcedureSummary({
    required final String id,
    required final String title,
    required final String procedureType,
    required final String status,
    required final String currentNodeId,
    required final DateTime createdAt,
    final DateTime? deadline,
  }) = _$ProcedureSummaryImpl;

  factory _ProcedureSummary.fromJson(Map<String, dynamic> json) =
      _$ProcedureSummaryImpl.fromJson;

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
  DateTime get createdAt;
  @override
  DateTime? get deadline;

  /// Create a copy of ProcedureSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProcedureSummaryImplCopyWith<_$ProcedureSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
