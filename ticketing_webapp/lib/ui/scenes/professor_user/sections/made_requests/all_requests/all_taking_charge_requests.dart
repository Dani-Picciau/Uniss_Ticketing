import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/made_requests/made_requests.dart';

class AllTakingChargeRequests extends StatelessWidget {
  const AllTakingChargeRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return MadeRequests(status: 'Presa in carico', showDeleteButton: false);
  }
}
