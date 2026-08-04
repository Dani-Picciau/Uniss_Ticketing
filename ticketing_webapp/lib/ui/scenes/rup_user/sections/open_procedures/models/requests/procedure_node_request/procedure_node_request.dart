import 'package:freezed_annotation/freezed_annotation.dart';

part 'procedure_node_request.freezed.dart';
part 'procedure_node_request.g.dart';

@freezed
class ProcedureNode with _$ProcedureNode {
  const factory ProcedureNode({
    required String nodeId,
    required String stageName,
    required String enabledRole,
    @Default([]) List<String> requirementsToSatisfy,
    required String nextNodeIfOk,
    required String nextNodeIfSkipped,
    String? skipCondition,
  }) = _ProcedureNode;

  factory ProcedureNode.fromJson(Map<String, dynamic> json) =>
      _$ProcedureNodeFromJson(json);
}
