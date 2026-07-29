import 'package:freezed_annotation/freezed_annotation.dart';

part 'node_status_request.freezed.dart';
part 'node_status_request.g.dart';

@freezed
class RequirementStatus with _$RequirementStatus {
  const factory RequirementStatus({
    required String requirementName,
    required bool satisfied,
  }) = _RequirementStatus;

  factory RequirementStatus.fromJson(Map<String, dynamic> json) =>
      _$RequirementStatusFromJson(json);
}
