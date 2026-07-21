import 'package:freezed_annotation/freezed_annotation.dart';

part 'professor_response.freezed.dart';
part 'professor_response.g.dart';

@freezed
class ProfessorResponse with _$ProfessorResponse {
  const factory ProfessorResponse({
    required String id,
    required String name,
    required String surname,
    String? title,
  }) = _ProfessorResponse;

  factory ProfessorResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfessorResponseFromJson(json);
}
