import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in_out.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_state.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/node/node_item.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/notes/open_close_notes.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/notes/procedure_notes.dart';
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
    // Utilizziamo BlocBuilder anziché BlocConsumer perché in questa vista
    // non abbiamo bisogno di gestire side-effect (es. SnackBar o Dialog),
    // ma soltanto di ricostruire reattivamente l'interfaccia in base al flag
    // state.showNotes per mostrare/nascondere il pannello laterale.
    return BlocBuilder<ProcedureTimelineCubit, ProcedureTimelineState>(
      builder: (context, state) {
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
                UnissLabel(
                  text: data.title,
                  textType: UnissTextType.headingMedium,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Divider(height: 10, color: context.colors.gray),

            const SizedBox(height: 8),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FadeIn(
                      offset: Offset(-150, 0),
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
                              context
                                  .read<ProcedureTimelineCubit>()
                                  .advanceStep();
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  FadeInOut(
                    child: state.showNotes
                        ? SizedBox(
                            key: const ValueKey('notes_opened'),
                            width: 400,
                            child: ProcedureNotes(),
                          )
                        : OpenCloseNotes(
                            key: const ValueKey('notes_closed'),
                            title: 'Note',
                            iconPath: MediaConstants.notes,
                            onTap: () => context
                                .read<ProcedureTimelineCubit>()
                                .toggleNotes(),
                          ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
