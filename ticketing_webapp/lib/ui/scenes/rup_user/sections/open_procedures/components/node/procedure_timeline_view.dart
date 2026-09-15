import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in_out.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/bloc/rup_user_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_state.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/node/node_item.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/notes/procedure_notes.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/ui_models/procedure_timeline_ui_model.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class ProcedureTimelineView extends StatelessWidget {
  final ProcedureTimelineUiModel data;
  final bool isReadOnly;

  const ProcedureTimelineView({
    super.key,
    required this.data,
    this.isReadOnly = false,
  });

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

    return BlocBuilder<ProcedureTimelineCubit, ProcedureTimelineState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // true quando il widget riceve un'altezza reale e finita,
            // come nel desktop dentro gli Expanded di AdminManagerScreen.
            //
            // false quando siamo dentro SingleChildScrollView,
            // dove l'altezza verticale è illimitata.
            final hasBoundedHeight = constraints.hasBoundedHeight;

            final header = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Torna alla lista',
                  onPressed: () {
                    context.read<ProcedureTimelineCubit>().clearSelection();

                    try {
                      context.read<AdminManagerCubit>().clearTargetProcedure();
                    } catch (_) {}
                  },
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UnissLabel(
                        text: data.title,
                        textType: UnissTextType.headingMedium,
                      ),

                      // Mostriamo le date solo se esistono
                      if (data.startDate != null || data.endDate != null) ...[
                        const SizedBox(height: 4),
                        UnissLabel(
                          text:
                              'Validità: ${data.startDate!.day}/${data.startDate!.month}/${data.startDate!.year} - '
                              '${data.endDate!.day}/${data.endDate!.month}/${data.endDate!.year}',
                          textType: UnissTextType.bodySmall,
                          color: context.colors.gray,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );

            final timeline = _buildTimeline(
              context,
              useListView: hasBoundedHeight,
            );

            final timelineWithNotes = _buildTimelineWithNotes(
              context,
              state,
              timeline,
              useFullHeightForNotes: hasBoundedHeight,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========================================================
                // HEADER
                // ========================================================
                header,

                const SizedBox(height: 8),

                Divider(height: 10, color: context.colors.gray),

                const SizedBox(height: 8),

                // ========================================================
                // TIMELINE
                // ========================================================
                //
                // DESKTOP:
                // Expanded dà allo Stack un'altezza finita.
                // La ListView può quindi fare scroll e le Note possono
                // occupare tutta l'altezza disponibile.
                //
                // MOBILE:
                // niente Expanded, perché siamo dentro
                // SingleChildScrollView.
                // La Column dei NodeItem determina l'altezza del contenuto.
                //
                if (hasBoundedHeight)
                  Expanded(child: timelineWithNotes)
                else
                  timelineWithNotes,
              ],
            );
          },
        );
      },
    );
  }

  // ======================================================================
  // TIMELINE
  // ======================================================================

  Widget _buildTimeline(BuildContext context, {required bool useListView}) {
    if (useListView) {
      return FadeIn(
        offset: const Offset(-50, 0),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: data.steps.length,
          itemBuilder: (context, index) {
            return _buildNodeItem(context, index);
          },
        ),
      );
    }

    return FadeIn(
      offset: const Offset(-50, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          data.steps.length,
          (index) => _buildNodeItem(context, index),
        ),
      ),
    );
  }

  // ======================================================================
  // TIMELINE + NOTE
  // ======================================================================

  Widget _buildTimelineWithNotes(
    BuildContext context,
    ProcedureTimelineState state,
    Widget timeline, {
    required bool useFullHeightForNotes,
  }) {
    // ---------------------------------------------------------------
    // DESKTOP
    // ---------------------------------------------------------------
    //
    // timeline è dentro un Expanded.
    // Di conseguenza lo Stack ha un'altezza finita.
    //
    // Le Note possono quindi usare top + bottom senza diventare infinite.
    // ---------------------------------------------------------------
    if (useFullHeightForNotes) {
      return Stack(
        children: [
          timeline,

          if (state.showNotes)
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: FadeInOut(
                child: SizedBox(
                  width: _notesWidth(context),
                  child: ProcedureNotes(isReadOnly: isReadOnly),
                ),
              ),
            ),
        ],
      );
    }

    // ---------------------------------------------------------------
    // MOBILE / SINGLECHILDSCROLLVIEW
    // ---------------------------------------------------------------
    //
    // Qui NON possiamo usare:
    //
    //   bottom: 0
    //
    // insieme a un'altezza verticale non limitata.
    //
    // Lasciamo quindi che il pannello Note utilizzi solamente la sua
    // altezza intrinseca.
    // ---------------------------------------------------------------
    return Stack(
      children: [
        timeline,

        if (state.showNotes)
          Positioned(
            top: 0,
            right: 0,
            child: FadeInOut(
              child: SizedBox(
                width: _notesWidth(context),
                child: ProcedureNotes(isReadOnly: isReadOnly),
              ),
            ),
          ),
      ],
    );
  }

  // ======================================================================
  // LARGHEZZA PANNELLO NOTE
  // ======================================================================

  double _notesWidth(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (screenWidth > 450) {
      return 400;
    }

    return screenWidth * 0.85;
  }

  // ======================================================================
  // NODE ITEM
  // ======================================================================

  Widget _buildNodeItem(BuildContext context, int index) {
    final step = data.steps[index];

    return NodeItem(
      title: step.title,
      rupBadge: step.rupBadge,
      adminBadge: step.adminBadge,
      requirements: step.requirements,
      isFirst: index == 0,
      isLast: index == data.steps.length - 1,
      isCompleted: step.isCompleted,
      isActive: step.isActive,
      nodeId: step.nodeId,
      notes: step.notes,
      isReadOnly: isReadOnly,
      onRequirementToggled: (reqName, isChecked) {
        context.read<ProcedureTimelineCubit>().toggleRequirement(
          reqName,
          isChecked,
        );
      },
      onAdvanceStep: () {
        context.read<ProcedureTimelineCubit>().advanceStep();
      },
    );
  }
}
