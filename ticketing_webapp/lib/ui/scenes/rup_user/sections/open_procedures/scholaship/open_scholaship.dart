import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/open_procedure_list/open_procedure_list.dart';

class OpenScholaship extends StatelessWidget {
  const OpenScholaship({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowOpenProcedureList(procedureType: 'BORSE_DI_STUDIO');
  }
}
