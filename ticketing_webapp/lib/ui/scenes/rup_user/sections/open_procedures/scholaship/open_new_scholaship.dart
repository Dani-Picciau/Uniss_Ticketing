import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/shared_timeline_procedures.dart';

class OpenNewScholaship extends StatelessWidget {
  final bool isRUP;
  const OpenNewScholaship({super.key, required this.isRUP});

  @override
  Widget build(BuildContext context) {
    return SharedTimelineProcedure(
      procedureType: 'BORSE_DI_STUDIO_NUOVA',
      isRUP: isRUP,
    );
  }
}
