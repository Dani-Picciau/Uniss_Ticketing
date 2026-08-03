import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/open_procedure_list/open_procedure_list.dart';

class OpenProceduresAll extends StatelessWidget {
  const OpenProceduresAll({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowOpenProcedureList(procedureType: '');
  }
}
