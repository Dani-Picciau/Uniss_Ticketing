import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/made_requests/made_requests.dart';

class PersonalTakingChargeRequests extends StatelessWidget {
  const PersonalTakingChargeRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return MadeRequests(
      status: 'Presa in carico',
      viewAs: 'DOCENTE',
      showDeleteButton: false,
    );
  }
}
