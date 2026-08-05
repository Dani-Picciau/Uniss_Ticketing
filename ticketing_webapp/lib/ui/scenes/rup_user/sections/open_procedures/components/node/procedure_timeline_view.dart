import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/node/node_item.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/ui_models/procedure_timeline_ui_model.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class ProcedureTimelineView extends StatelessWidget {
  final ProcedureTimelineUiModel data;

  const ProcedureTimelineView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.steps.isEmpty) {
      return Center(
        child: UnissLabel(
          text: "Nessuna fase da visualizzare",
          textType: UnissTextType.bodySmall,
        ),
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
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // Allunga i figli in verticale al 100%
            children: [
              Expanded(
                flex: 3, // 60% della larghezza
                child: FadeIn(
                  offset: Offset(-50, 0),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
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
                        onRequirementToggled: (reqName, isChecked) {
                          context
                              .read<ProcedureTimelineCubit>()
                              .toggleRequirement(reqName, isChecked);
                        },
                        onAdvanceStep: () {
                          context.read<ProcedureTimelineCubit>().advanceStep();
                        },
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2, // 40% della larghezza
                child: FadeIn(
                  duration: Duration(milliseconds: 300),
                  offset: const Offset(50, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colors.whiteAlpha07,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.blackAlpha015,
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          UnissLabel(
                            text: 'Note',
                            textType: UnissTextType.headingMedium,
                          ),
                          Divider(height: 10, color: context.colors.gray),
                        ],
                      ),
                    ),
                    // In futuro qui potrai mettere una Column o un form per le note
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}
