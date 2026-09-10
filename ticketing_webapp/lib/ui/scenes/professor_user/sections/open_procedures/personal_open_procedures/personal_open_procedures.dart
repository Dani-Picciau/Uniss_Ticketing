import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/shared_timeline_procedures.dart';

class PersonalOpenProcedures extends StatelessWidget {
  const PersonalOpenProcedures({super.key});

  @override
  Widget build(BuildContext context) {
    return const SharedTimelineProcedure(
      viewAs: 'DOCENTE',
      showReassignButton: false,
      showDeleteButton: false,
      showDeadline: false,
    );
  }
}
