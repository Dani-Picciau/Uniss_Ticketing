import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/incoming_requests/incoming_requests.dart';

class AssignedRequests extends StatelessWidget {
  final bool isRUP;

  const AssignedRequests({super.key, required this.isRUP});

  @override
  Widget build(BuildContext context) {
    return IncomingRequests(
      requestStatus: 'Assegnata',
      showReassignButton: isRUP ? true : false,
    );
  }
}
