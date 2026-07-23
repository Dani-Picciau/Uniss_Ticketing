import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/response/administrator_response/administrator_response.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/sections/new_procedure/data/models/response/professor_response/professor_response.dart';

class UserUiModel {
  final String id;
  final String displayName;

  UserUiModel({required this.id, required this.displayName});

  factory UserUiModel.fromProfessor(ProfessorResponse p) {
    final titleString = (p.title != null && p.title!.isNotEmpty)
        ? '${p.title} '
        : '';
    return UserUiModel(
      id: p.id,
      displayName: '$titleString${p.name} ${p.surname}'.trim(),
    );
  }

  factory UserUiModel.fromAdministrator(AdministratorResponse a) {
    final titleString = (a.title != null && a.title!.isNotEmpty)
        ? '${a.title} '
        : '';
    return UserUiModel(
      id: a.id,
      displayName: '$titleString${a.name} ${a.surname}'.trim(),
    );
  }
}
