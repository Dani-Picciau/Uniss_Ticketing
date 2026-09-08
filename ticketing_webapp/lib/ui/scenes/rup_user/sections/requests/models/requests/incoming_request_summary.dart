import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_request_summary.freezed.dart';
part 'incoming_request_summary.g.dart';

@freezed
class IncomingRequestSummary with _$IncomingRequestSummary {
  const factory IncomingRequestSummary({
    required String id,
    required String requestingProfessorName,
    required String subject,
    required String content,
    required String status,
    required DateTime createdAt,
    String? linkedProcedureId,
  }) = _IncomingRequestSummary;

  factory IncomingRequestSummary.fromJson(Map<String, dynamic> json) =>
      _$IncomingRequestSummaryFromJson(json);
}
