import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/deadlines/deadline_screen.dart';

class ConsumerGoodsDeadlineOutMepa extends StatelessWidget {
  const ConsumerGoodsDeadlineOutMepa({super.key});

  @override
  Widget build(BuildContext context) {
    return DeadlineScreen(procedureType: 'ORDINI_FUORI_MEPA_BENI_CONSUMO');
  }
}
