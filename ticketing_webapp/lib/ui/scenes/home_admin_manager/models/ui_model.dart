import 'package:ticketing_webapp/data/models/login_response.dart';

class AdminManagerUiModel {
  final String welcomeMessage;
  final String name;
  final String surname;
  final String? title;
  final String initials;

  AdminManagerUiModel({
    required this.welcomeMessage,
    required this.name,
    required this.surname,
    this.title,
    required this.initials,
  });

  factory AdminManagerUiModel.fromAuthResult(LoginResponse data) {
    String initialNameCharacter = data.name.substring(0, 1);
    String initialSurnameCharacter = data.surname.substring(0, 1);
    String initials = '$initialNameCharacter$initialSurnameCharacter';

    return AdminManagerUiModel(
      welcomeMessage: 'Salve ${data.title} ${data.name} ${data.surname}',
      name: data.name,
      surname: data.surname,
      initials: initials,
    );
  }
}
