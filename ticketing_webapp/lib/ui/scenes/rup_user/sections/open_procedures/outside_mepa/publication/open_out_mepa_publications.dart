import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/shared_timeline_procedures.dart';

class OpenOutMepaPublications extends StatelessWidget {
  final bool isRUP;
  const OpenOutMepaPublications({super.key, required this.isRUP});

  @override
  Widget build(BuildContext context) {
    return SharedTimelineProcedure(
      procedureType: 'PUBBLICAZIONI_ESTERE',
      isRUP: isRUP,
    );
  }
}
