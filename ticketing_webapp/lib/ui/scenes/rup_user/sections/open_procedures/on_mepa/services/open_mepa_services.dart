import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/open_procedure_list/open_procedure_list.dart';

class OpenMepaServices extends StatelessWidget {
  const OpenMepaServices({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowOpenProcedureList(procedureType: 'ORDINI_SERVIZI_SU_MEPA');
  }
}
