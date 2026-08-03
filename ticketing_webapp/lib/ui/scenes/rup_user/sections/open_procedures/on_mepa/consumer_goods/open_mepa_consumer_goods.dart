import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/open_procedure_list/open_procedure_list.dart';

class OpenMepaConsumerGoods extends StatelessWidget {
  const OpenMepaConsumerGoods({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowOpenProcedureList(procedureType: 'ORDINI_SU_MEPA_BENI_CONSUMO');
  }
}


    /* return ListView(
      shrinkWrap: true, 
      physics:
          const NeverScrollableScrollPhysics(), 
      children: const [
        NodeItem(
          title: 'Preordine del Responsabile Scientifico',
          role: 'DOCENTE_RICHIEDENTE',
          requirements: [
            'Preventivo/quotazione informale',
            'Dichiarazione di scelta con firma',
          ],
          isFirst: true,
          isCompleted: true,
        ),
        NodeItem(
          title: 'Prime Verifiche Amministrative',
          role: 'RUP',
          requirements: ['DURC', 'Documento anticorruzione'],
          isActive: true,
        ),
        NodeItem(
          title: 'Documentazione da Caricare su MEPA',
          role: 'RUP',
          requirements: ['Autocertificazione antimafia', 'Riga unica MEPA'],
          isLast: true,
        ),
      ],
    ); */