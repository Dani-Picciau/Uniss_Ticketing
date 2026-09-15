import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/shared_timeline_procedures.dart';

class OpenOutMepaConsumerGoods extends StatelessWidget {
  final bool isRUP;
  const OpenOutMepaConsumerGoods({super.key, required this.isRUP});

  @override
  Widget build(BuildContext context) {
    return SharedTimelineProcedure(
      procedureType: 'ORDINI_FUORI_MEPA_BENI_CONSUMO',
      isRUP: isRUP,
    );
  }
}
