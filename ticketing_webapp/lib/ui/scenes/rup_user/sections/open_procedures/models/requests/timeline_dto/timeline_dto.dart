import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeline_dto.freezed.dart';
part 'timeline_dto.g.dart';

@freezed
class TimelineDto with _$TimelineDto {
  const factory TimelineDto({
    required String procedureId,
    required String title,
    required String status,
    @Default([]) List<TimelineStepDto> steps,
  }) = _TimelineDto;

  factory TimelineDto.fromJson(Map<String, dynamic> json) =>
      _$TimelineDtoFromJson(json);
}

@freezed
class TimelineStepDto with _$TimelineStepDto {
  const factory TimelineStepDto({
    required String nodeId,
    required String stageName,
    String? enabledRole,
    @Default([]) List<String> requirementsToSatisfy,
    required bool completed,
    required bool active,
  }) = _TimelineStepDto;

  // Assicurati che qui ci sia ".fromJson" e il nome corretto!
  factory TimelineStepDto.fromJson(Map<String, dynamic> json) =>
      _$TimelineStepDtoFromJson(json);
}
