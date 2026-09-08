import 'package:flutter/widgets.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/requests/components/professor_request_list/professor_request_list.dart';

class IncomingRequests extends StatelessWidget {
  const IncomingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowProfessorsRequestsList(statusType: 'In attesa');
  }
}
