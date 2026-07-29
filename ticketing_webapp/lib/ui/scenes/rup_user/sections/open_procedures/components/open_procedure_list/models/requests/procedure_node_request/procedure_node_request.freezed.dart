// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'procedure_node_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProcedureNode _$ProcedureNodeFromJson(Map<String, dynamic> json) {
  return _ProcedureNode.fromJson(json);
}

/// @nodoc
mixin _$ProcedureNode {
  String get nodeId => throw _privateConstructorUsedError;
  String get stageName => throw _privateConstructorUsedError;
  String get enabledRole => throw _privateConstructorUsedError;
  List<String> get requirementsToSatisfy => throw _privateConstructorUsedError;
  String get nextNodeIfOk => throw _privateConstructorUsedError;
  String get nextNodeIfSkipped => throw _privateConstructorUsedError;
  String? get skipCondition => throw _privateConstructorUsedError;

  /// Serializes this ProcedureNode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProcedureNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProcedureNodeCopyWith<ProcedureNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProcedureNodeCopyWith<$Res> {
  factory $ProcedureNodeCopyWith(
    ProcedureNode value,
    $Res Function(ProcedureNode) then,
  ) = _$ProcedureNodeCopyWithImpl<$Res, ProcedureNode>;
  @useResult
  $Res call({
    String nodeId,
    String stageName,
    String enabledRole,
    List<String> requirementsToSatisfy,
    String nextNodeIfOk,
    String nextNodeIfSkipped,
    String? skipCondition,
  });
}

/// @nodoc
class _$ProcedureNodeCopyWithImpl<$Res, $Val extends ProcedureNode>
    implements $ProcedureNodeCopyWith<$Res> {
  _$ProcedureNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProcedureNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodeId = null,
    Object? stageName = null,
    Object? enabledRole = null,
    Object? requirementsToSatisfy = null,
    Object? nextNodeIfOk = null,
    Object? nextNodeIfSkipped = null,
    Object? skipCondition = freezed,
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
            enabledRole: null == enabledRole
                ? _value.enabledRole
                : enabledRole // ignore: cast_nullable_to_non_nullable
                      as String,
            requirementsToSatisfy: null == requirementsToSatisfy
                ? _value.requirementsToSatisfy
                : requirementsToSatisfy // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            nextNodeIfOk: null == nextNodeIfOk
                ? _value.nextNodeIfOk
                : nextNodeIfOk // ignore: cast_nullable_to_non_nullable
                      as String,
            nextNodeIfSkipped: null == nextNodeIfSkipped
                ? _value.nextNodeIfSkipped
                : nextNodeIfSkipped // ignore: cast_nullable_to_non_nullable
                      as String,
            skipCondition: freezed == skipCondition
                ? _value.skipCondition
                : skipCondition // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProcedureNodeImplCopyWith<$Res>
    implements $ProcedureNodeCopyWith<$Res> {
  factory _$$ProcedureNodeImplCopyWith(
    _$ProcedureNodeImpl value,
    $Res Function(_$ProcedureNodeImpl) then,
  ) = __$$ProcedureNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String nodeId,
    String stageName,
    String enabledRole,
    List<String> requirementsToSatisfy,
    String nextNodeIfOk,
    String nextNodeIfSkipped,
    String? skipCondition,
  });
}

/// @nodoc
class __$$ProcedureNodeImplCopyWithImpl<$Res>
    extends _$ProcedureNodeCopyWithImpl<$Res, _$ProcedureNodeImpl>
    implements _$$ProcedureNodeImplCopyWith<$Res> {
  __$$ProcedureNodeImplCopyWithImpl(
    _$ProcedureNodeImpl _value,
    $Res Function(_$ProcedureNodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProcedureNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodeId = null,
    Object? stageName = null,
    Object? enabledRole = null,
    Object? requirementsToSatisfy = null,
    Object? nextNodeIfOk = null,
    Object? nextNodeIfSkipped = null,
    Object? skipCondition = freezed,
  }) {
    return _then(
      _$ProcedureNodeImpl(
        nodeId: null == nodeId
            ? _value.nodeId
            : nodeId // ignore: cast_nullable_to_non_nullable
                  as String,
        stageName: null == stageName
            ? _value.stageName
            : stageName // ignore: cast_nullable_to_non_nullable
                  as String,
        enabledRole: null == enabledRole
            ? _value.enabledRole
            : enabledRole // ignore: cast_nullable_to_non_nullable
                  as String,
        requirementsToSatisfy: null == requirementsToSatisfy
            ? _value._requirementsToSatisfy
            : requirementsToSatisfy // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        nextNodeIfOk: null == nextNodeIfOk
            ? _value.nextNodeIfOk
            : nextNodeIfOk // ignore: cast_nullable_to_non_nullable
                  as String,
        nextNodeIfSkipped: null == nextNodeIfSkipped
            ? _value.nextNodeIfSkipped
            : nextNodeIfSkipped // ignore: cast_nullable_to_non_nullable
                  as String,
        skipCondition: freezed == skipCondition
            ? _value.skipCondition
            : skipCondition // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProcedureNodeImpl implements _ProcedureNode {
  const _$ProcedureNodeImpl({
    required this.nodeId,
    required this.stageName,
    required this.enabledRole,
    final List<String> requirementsToSatisfy = const [],
    required this.nextNodeIfOk,
    required this.nextNodeIfSkipped,
    this.skipCondition,
  }) : _requirementsToSatisfy = requirementsToSatisfy;

  factory _$ProcedureNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProcedureNodeImplFromJson(json);

  @override
  final String nodeId;
  @override
  final String stageName;
  @override
  final String enabledRole;
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
  final String nextNodeIfOk;
  @override
  final String nextNodeIfSkipped;
  @override
  final String? skipCondition;

  @override
  String toString() {
    return 'ProcedureNode(nodeId: $nodeId, stageName: $stageName, enabledRole: $enabledRole, requirementsToSatisfy: $requirementsToSatisfy, nextNodeIfOk: $nextNodeIfOk, nextNodeIfSkipped: $nextNodeIfSkipped, skipCondition: $skipCondition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProcedureNodeImpl &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.stageName, stageName) ||
                other.stageName == stageName) &&
            (identical(other.enabledRole, enabledRole) ||
                other.enabledRole == enabledRole) &&
            const DeepCollectionEquality().equals(
              other._requirementsToSatisfy,
              _requirementsToSatisfy,
            ) &&
            (identical(other.nextNodeIfOk, nextNodeIfOk) ||
                other.nextNodeIfOk == nextNodeIfOk) &&
            (identical(other.nextNodeIfSkipped, nextNodeIfSkipped) ||
                other.nextNodeIfSkipped == nextNodeIfSkipped) &&
            (identical(other.skipCondition, skipCondition) ||
                other.skipCondition == skipCondition));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    nodeId,
    stageName,
    enabledRole,
    const DeepCollectionEquality().hash(_requirementsToSatisfy),
    nextNodeIfOk,
    nextNodeIfSkipped,
    skipCondition,
  );

  /// Create a copy of ProcedureNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProcedureNodeImplCopyWith<_$ProcedureNodeImpl> get copyWith =>
      __$$ProcedureNodeImplCopyWithImpl<_$ProcedureNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProcedureNodeImplToJson(this);
  }
}

abstract class _ProcedureNode implements ProcedureNode {
  const factory _ProcedureNode({
    required final String nodeId,
    required final String stageName,
    required final String enabledRole,
    final List<String> requirementsToSatisfy,
    required final String nextNodeIfOk,
    required final String nextNodeIfSkipped,
    final String? skipCondition,
  }) = _$ProcedureNodeImpl;

  factory _ProcedureNode.fromJson(Map<String, dynamic> json) =
      _$ProcedureNodeImpl.fromJson;

  @override
  String get nodeId;
  @override
  String get stageName;
  @override
  String get enabledRole;
  @override
  List<String> get requirementsToSatisfy;
  @override
  String get nextNodeIfOk;
  @override
  String get nextNodeIfSkipped;
  @override
  String? get skipCondition;

  /// Create a copy of ProcedureNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProcedureNodeImplCopyWith<_$ProcedureNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
