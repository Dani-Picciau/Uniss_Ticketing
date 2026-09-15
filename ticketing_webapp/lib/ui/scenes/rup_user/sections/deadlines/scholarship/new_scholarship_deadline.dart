import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/deadline_screen.dart';

class NewScholarshipDeadline extends StatelessWidget {
  const NewScholarshipDeadline({super.key});

  @override
  Widget build(BuildContext context) {
    return DeadlineScreen(procedureType: 'BORSE_DI_STUDIO_NUOVA');
  }
}
