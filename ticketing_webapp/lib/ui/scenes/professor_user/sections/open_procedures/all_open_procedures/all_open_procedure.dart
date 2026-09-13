import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/shared_timeline_procedures.dart';

class AllOpenProcedures extends StatelessWidget {
  const AllOpenProcedures({super.key});

  @override
  Widget build(BuildContext context) {
    return const SharedTimelineProcedure(
      status: 'Attiva',
      showReassignButton: false,
      showDeleteButton: false,
      showDeadline: false,
      isReadOnly: true,
    );
  }
}
