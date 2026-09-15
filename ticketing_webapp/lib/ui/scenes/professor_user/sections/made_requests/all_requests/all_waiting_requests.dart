import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/made_requests/made_requests.dart';

class AllWaitingRequests extends StatelessWidget {
  const AllWaitingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return MadeRequests(status: 'In attesa');
  }
}
