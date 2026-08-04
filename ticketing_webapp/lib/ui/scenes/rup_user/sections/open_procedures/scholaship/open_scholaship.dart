import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/shared_timeline_procedures.dart';

class OpenScholaship extends StatelessWidget {
  const OpenScholaship({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedTimelineProcedure(procedureType: 'BORSE_DI_STUDIO');
  }
}
