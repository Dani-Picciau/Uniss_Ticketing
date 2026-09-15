import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/shared_timeline_procedures.dart';

class OpenRenewalScholaship extends StatelessWidget {
  final bool isRUP;
  const OpenRenewalScholaship({super.key, required this.isRUP});

  @override
  Widget build(BuildContext context) {
    return SharedTimelineProcedure(
      procedureType: 'BORSE_DI_STUDIO_RINNOVO',
      isRUP: isRUP,
    );
  }
}
