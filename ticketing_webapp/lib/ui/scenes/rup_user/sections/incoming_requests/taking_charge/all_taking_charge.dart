import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/incoming_requests/incoming_requests.dart';

class AllTakingCharge extends StatelessWidget {
  const AllTakingCharge({super.key});

  @override
  Widget build(BuildContext context) {
    return IncomingRequests(requestStatus: 'Presa in carico');
  }
}
