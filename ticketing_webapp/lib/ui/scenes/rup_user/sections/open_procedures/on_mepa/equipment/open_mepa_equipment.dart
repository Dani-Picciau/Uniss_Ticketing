import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/shared_timeline_procedures.dart';

class OpenMepaEquipment extends StatelessWidget {
  const OpenMepaEquipment({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedTimelineProcedure(
      procedureType: 'ORDINI_SU_MEPA_ATTREZZATURE',
    );
  }
}
