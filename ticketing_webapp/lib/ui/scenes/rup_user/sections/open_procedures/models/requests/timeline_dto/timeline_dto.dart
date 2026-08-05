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
    @Default([]) List<RequirementStatusDto> requirements,
    required bool completed,
    required bool active,
  }) = _TimelineStepDto;

  factory TimelineStepDto.fromJson(Map<String, dynamic> json) =>
      _$TimelineStepDtoFromJson(json);
}

// NUOVA CLASSE PER IL SINGOLO REQUISITO:
@freezed
class RequirementStatusDto with _$RequirementStatusDto {
  const factory RequirementStatusDto({
    required String name,
    required bool satisfied,
  }) = _RequirementStatusDto;

  factory RequirementStatusDto.fromJson(Map<String, dynamic> json) =>
      _$RequirementStatusDtoFromJson(json);
}