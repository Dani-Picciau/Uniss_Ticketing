import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/components/deadline_screen.dart';

class RenewalScholarshipDeadline extends StatelessWidget {
  const RenewalScholarshipDeadline({super.key});

  @override
  Widget build(BuildContext context) {
    return DeadlineScreen(procedureType: 'BORSE_DI_STUDIO_RINNOVO');
  }
}
