import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/components/deadline_screen.dart';

class OnMepaEquipmentDeadline extends StatelessWidget {
  const OnMepaEquipmentDeadline({super.key});

  @override
  Widget build(BuildContext context) {
    return DeadlineScreen(procedureType: 'ORDINI_SU_MEPA_ATTREZZATURE');
  }
}
