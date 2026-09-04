import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/snackbar/uniss_snackbar.dart';
import 'package:ticketing_webapp/ui/components/uniss_buttons/uniss_icon_button.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_cubit.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/bloc/procedure_timeline_state.dart';

class ProcedureNotes extends StatelessWidget {
  const ProcedureNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProcedureTimelineCubit, ProcedureTimelineState>(
      // 1. IL FILTRO INTELLIGENTE: Ascolta solo la fine di un salvataggio
      listenWhen: (previous, current) {
        return previous.isSavingNote == true && current.isSavingNote == false;
      },

      // Listener per le snackbar
      listener: (context, state) {
        if (state.errorMessage != null) {
          // Salvataggio note non andato a buon fine
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
          // SALVATAGGIO RIUSCITO (Nessun errore)
          ScaffoldMessenger.of(context).showSnackBar(
            buildMessangerSnackBar(
              context,
              text: 'Note salvate con successo!',
              iconPath: MediaConstants
                  .success, // Usa l'icona di successo che hai nei constants
              textColor: context.colors.white,
              backgroundColor: Colors.green,
            ),
          );
        }
      },

      // Builder
      builder: (context, state) {
        final uiModel = state.uiModel;
        final selectedNodeId = state.selectedNodeIdForNotes;

        // Troviamo lo step attualmente selezionato estraendolo dalla lista
        final selectedStep = uiModel?.steps
            .where((s) => s.nodeId == selectedNodeId)
            .firstOrNull;

        // È editabile solo se lo step è attivo (non completato)
        final bool isEditable = selectedStep?.isActive ?? false;

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
            children: [
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
                        iconHeight: 22,
                        iconWidth: 22,
                        padding: const EdgeInsets.all(3),
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

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isEditable ? Colors.white : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),

                  child: TextField(
                    controller:
                        TextEditingController(text: state.currentNoteText)
                          ..selection = TextSelection.collapsed(
                            offset: state.currentNoteText.length,
                          ),
                    onChanged: (text) => context
                        .read<ProcedureTimelineCubit>()
                        .updateNoteText(text),
                    maxLines: null,
                    expands: true,
                    readOnly:
                        !isEditable, // Blocchiamo la scrittura se è uno step storico!
                    style: unissTextTheme.bodySmall,
                    decoration: InputDecoration(
                      hintText: isEditable
                          ? 'Scrivi qui le note operative per questo step...'
                          : 'Nessuna nota presente.',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),

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
                      ? null // Disabilita il click mentre salva
                      : () {
                          if (uiModel != null) {
                            context.read<ProcedureTimelineCubit>().saveNotes(
                              uiModel.id,
                            );
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
  }
}
