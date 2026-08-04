import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/node/node_item.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/ui_models/procedure_timeline_ui_model.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class ProcedureTimelineView extends StatelessWidget {
  final ProcedureTimelineUiModel data;

  const ProcedureTimelineView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.steps.isEmpty) {
      return UnissLabel(
        text: "Nessuna fase da visualizzare",
        textType: UnissTextType.bodySmall,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Torna alla lista',
              onPressed: () {
                context.read<ProcedureTimelineCubit>().clearSelection();
              },
            ),
            const SizedBox(width: 8),
            UnissLabel(text: data.title, textType: UnissTextType.headingMedium),
          ],
        ),

        ListView.builder(
          padding: EdgeInsets.all(0),
          
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.steps.length,
          itemBuilder: (context, index) {
            final step = data.steps[index];
            return NodeItem(
              title: step.title,
              role: step.role,
              requirements: step.requirements,
              isFirst: index == 0,
              isLast: index == data.steps.length - 1,
              isCompleted: step.isCompleted,
              isActive: step.isActive,
            );
          },
        ),
      ],
    );
  }
}
