import 'package:freezed_annotation/freezed_annotation.dart';

part 'administrator_response.freezed.dart';
part 'administrator_response.g.dart';

@freezed
class AdministratorResponse with _$AdministratorResponse {
  const factory AdministratorResponse({
    required String id,
    required String name,
    required String surname,
    String? title,
  }) = _AdministratorResponse;

  factory AdministratorResponse.fromJson(Map<String, dynamic> json) =>
      _$AdministratorResponseFromJson(json);
}
