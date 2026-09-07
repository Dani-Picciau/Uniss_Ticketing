import 'package:freezed_annotation/freezed_annotation.dart';

part 'professor_request.freezed.dart';
part 'professor_request.g.dart';

@freezed
class ProfessorRequest with _$ProfessorRequest {
  const factory ProfessorRequest({
    required String subject,
    required String content,
  }) = _ProfessorRequest;

  factory ProfessorRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfessorRequestFromJson(json);
}
