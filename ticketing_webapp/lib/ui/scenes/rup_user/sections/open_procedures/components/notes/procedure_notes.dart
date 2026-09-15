import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/components/uniss_buttons/uniss_icon_button.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_state.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class ProcedureNotes extends StatelessWidget {
  final bool isReadOnly;

  const ProcedureNotes({super.key, this.isReadOnly = false});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProcedureTimelineCubit, ProcedureTimelineState>(
      // Ascolta solo la fine del salvataggio
      listenWhen: (previous, current) {
        return previous.isSavingNote == true && current.isSavingNote == false;
      },

      // Listener per le snackbar
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildMessangerSnackBar(
              context,
              text: state.errorMessage!,
              iconPath: MediaConstants.error,
              textColor: context.colors.white,
              backgroundColor: context.colors.errorMessage,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            buildMessangerSnackBar(
              context,
              text: 'Note salvate con successo!',
              iconPath: MediaConstants.success,
              textColor: context.colors.white,
              backgroundColor: Colors.green,
            ),
          );
        }
      },

      builder: (context, state) {
        final uiModel = state.uiModel;
        final selectedNodeId = state.selectedNodeIdForNotes;

        // Troviamo lo step attualmente selezionato
        final selectedStep = uiModel?.steps
            .where((s) => s.nodeId == selectedNodeId)
            .firstOrNull;

        // Modificabile solo se lo step è attivo e non siamo in sola lettura
        final bool isEditable =
            (selectedStep?.isActive ?? false) && !isReadOnly;

        return LayoutBuilder(
          builder: (context, constraints) {
            // true = abbiamo un'altezza finita.
            //
            // Questo è il caso desktop, dove ProcedureNotes è dentro
            // uno Stack a sua volta dentro un Expanded.
            final hasBoundedHeight = constraints.hasBoundedHeight;

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF9F6),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: hasBoundedHeight
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                children: [
                  // ======================================================
                  // HEADER
                  // ======================================================
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: UnissLabel(
                              text: 'Note',
                              textType: UnissTextType.headingMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          UnissIconButton(
                            backgroundColor: context.colors.transparent,
                            hoverColor: context.colors.blackAlpha01,
                            splashColor: context.colors.blackAlpha015,
                            iconHeight: 20,
                            iconWidth: 20,
                            padding: const EdgeInsets.all(5),
                            iconPath: MediaConstants.closeOnRight,
                            onTap: () => context
                                .read<ProcedureTimelineCubit>()
                                .toggleNotes(nodeId: selectedNodeId),
                          ),
                        ],
                      ),

                      UnissLabel(
                        text: selectedStep?.title ?? "",
                        textType: UnissTextType.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  const Divider(height: 20),

                  // ======================================================
                  // CAMPO NOTE
                  // ======================================================
                  if (hasBoundedHeight)
                    // ----------------------------------------------------
                    // DESKTOP
                    // ----------------------------------------------------
                    // Abbiamo un'altezza disponibile.
                    //
                    // Possiamo usare Expanded + expands:true.
                    // ----------------------------------------------------
                    Expanded(
                      child: _buildNoteField(
                        context,
                        state,
                        isEditable,
                        expands: true,
                      ),
                    )
                  else
                    // ----------------------------------------------------
                    // MOBILE / SCHERMATA STRETTA
                    // ----------------------------------------------------
                    // L'altezza è illimitata perché siamo dentro lo
                    // SingleChildScrollView.
                    //
                    // Niente Expanded.
                    // Niente expands:true.
                    //
                    // Usiamo invece un'altezza minima ragionevole e il
                    // TextField può crescere normalmente.
                    SizedBox(
                      height: 250,
                      child: _buildNoteField(
                        context,
                        state,
                        isEditable,
                        expands: false,
                      ),
                    ),

                  // ======================================================
                  // PULSANTE SALVA
                  // ======================================================
                  if (isEditable) ...[
                    const SizedBox(height: 16),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: state.isSavingNote
                          ? null
                          : () {
                              if (uiModel != null) {
                                context
                                    .read<ProcedureTimelineCubit>()
                                    .saveNotes(uiModel.id);
                              }
                            },
                      child: state.isSavingNote
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const UnissLabel(
                              text: 'Salva Note',
                              textType: UnissTextType.labelMedium,
                              color: Colors.white,
                            ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ======================================================================
  // TEXT FIELD NOTE
  // ======================================================================

  Widget _buildNoteField(
    BuildContext context,
    ProcedureTimelineState state,
    bool isEditable, {
    required bool expands,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEditable ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: TextEditingController(text: state.currentNoteText)
          ..selection = TextSelection.collapsed(
            offset: state.currentNoteText.length,
          ),
        onChanged: (text) =>
            context.read<ProcedureTimelineCubit>().updateNoteText(text),
        maxLines: expands ? null : 10,
        minLines: expands ? null : 5,
        expands: expands,
        readOnly: !isEditable,
        style: unissTextTheme.bodySmall,
        decoration: InputDecoration(
          hintText: isEditable
              ? 'Scrivi qui le note operative per questo step...'
              : 'Nessuna nota presente.',
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}
