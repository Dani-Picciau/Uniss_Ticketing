import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/deadline_screen.dart';

class PublicationDeadlines extends StatelessWidget {
  const PublicationDeadlines({super.key});

  @override
  Widget build(BuildContext context) {
    return DeadlineScreen(procedureType: 'PUBBLICAZIONI_ESTERE');
  }
}
