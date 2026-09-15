import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/deadline_screen.dart';

class OnMepaServicesDeadline extends StatelessWidget {
  const OnMepaServicesDeadline({super.key});

  @override
  Widget build(BuildContext context) {
    return DeadlineScreen(procedureType: 'ORDINI_SERVIZI_SU_MEPA');
  }
}
