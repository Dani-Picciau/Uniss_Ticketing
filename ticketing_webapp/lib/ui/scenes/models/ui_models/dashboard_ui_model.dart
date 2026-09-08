import 'package:ticketing_webapp/features/models/login_response.dart';

class DashboardUserUiModel {
  final String welcomeMessage;
  final String userId;
  final String name;
  final String surname;
  final String? title;
  final String initials;
  final List<String> roles;

  DashboardUserUiModel({
    required this.welcomeMessage,
    required this.name,
    required this.surname,
    required this.initials,
    required this.userId,
    required this.roles,
    this.title,
  });

  factory DashboardUserUiModel.fromAuthResult(LoginResponse data) {
    String initialNameCharacter = data.name.substring(0, 1);
    String initialSurnameCharacter = data.surname.substring(0, 1);
    String initials = '$initialNameCharacter$initialSurnameCharacter';

    return DashboardUserUiModel(
      welcomeMessage: 'Salve ${data.title} ${data.name} ${data.surname}',
      userId: data.userId,
      name: data.name,
      surname: data.surname,
      initials: initials,
      roles: data.roles,
    );
  }
}
