import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/shared_timeline_procedures.dart';

class OpenMepaServices extends StatelessWidget {
  final bool isRUP;
  const OpenMepaServices({super.key, required this.isRUP});

  @override
  Widget build(BuildContext context) {
    return SharedTimelineProcedure(
      procedureType: 'ORDINI_SERVIZI_SU_MEPA',
      isRUP: isRUP,
    );
  }
}
