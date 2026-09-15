import 'package:freezed_annotation/freezed_annotation.dart';

part 'assign_request_dto.freezed.dart';
part 'assign_request_dto.g.dart';

@freezed
class AssignRequestDto with _$AssignRequestDto {
  const factory AssignRequestDto({required String administratorId}) =
      _AssignRequestDto;

  factory AssignRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AssignRequestDtoFromJson(json);
}
