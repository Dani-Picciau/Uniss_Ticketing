import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/components/deadline_screen.dart';

class AllDeadlines extends StatelessWidget {
  const AllDeadlines({super.key});

  @override
  Widget build(BuildContext context) {
    return DeadlineScreen(procedureType: '');
  }
}
