import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/ui/components/overlay_confirm_message/uniss_dialogs.dart.dart';

import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/uniss_buttons/uniss_icon_button.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/open_procedure_list/bloc/procedure_list_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/procedure_summary/procedure_summary.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class OpenProcedureListItem extends StatefulWidget {
  final ProcedureSummary procedure;
  final VoidCallback onTap;

  const OpenProcedureListItem({
    super.key,
    required this.procedure,
    required this.onTap,
  });

  @override
  State<OpenProcedureListItem> createState() => _OpenProcedureListItemState();
}

class _OpenProcedureListItemState extends State<OpenProcedureListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFAF9F6),

      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onHover: (isHovering) => setState(() => _isHovered = isHovering),
        onTap: widget.onTap,
        hoverColor: Colors.transparent,
        splashColor: context.colors.blackAlpha01,
        borderRadius: BorderRadius.circular(8),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          padding: _isHovered
              ? const EdgeInsets.only(left: 24, right: 16, top: 12, bottom: 12)
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? context.colors.blackAlpha01 : null,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.colors.lightGray),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UnissLabel(
                      text: widget.procedure.title,
                      textType: UnissTextType.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    UnissLabel(
                      text: 'Fase attuale: ${widget.procedure.currentNodeId}',
                      textType: UnissTextType.bodySmall,
                      color: context.colors.gray,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              SizedBox(width: 50),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: widget.procedure.status == 'COMPLETATA'
                      ? Colors.green.shade100
                      : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.procedure.status == 'COMPLETATA'
                        ? Colors.green.shade300
                        : Colors.blue.shade300,
                  ),
                ),
                child: UnissLabel(
                  text: widget.procedure.status,
                  textType: UnissTextType.bodySmall,
                  color: widget.procedure.status == 'COMPLETATA'
                      ? Colors.green.shade800
                      : Colors.blue.shade800,
                ),
              ),

              SizedBox(width: 8),

              UnissIconButton(
                onTap: () {
                  UnissDialogs.showConfirmation(
                    context,
                    message: 'Riasegnazione della procedura',
                    confirmText: 'Riassegna',
                    onConfirm: () {},
                  );
                },
                iconPath: MediaConstants.reassigns,
                iconColor: const Color(0xFFD35400),
                backgroundColor: const Color(
                  0xFFFFF3E0,
                ), // Arancione chiarissimo (pastello)
                hoverColor: const Color.fromARGB(255, 255, 214, 149),
                splashColor: context.colors.blackAlpha01,
                borderColor: const Color(
                  0xFFD35400,
                ), // Arancione scuro/intenso (zucca)
                width: 20,
                height: 20,
                padding: const EdgeInsets.all(9),
                tooltip: 'Riassegna procedura',
              ),

              SizedBox(width: 8),

              UnissIconButton(
                onTap: () {
                  UnissDialogs.showConfirmation(
                    context,
                    message: 'Sei sicuro di voler eliminare questa procedura?',
                    confirmText: 'Elimina',
                    onConfirm: () {
                      context.read<ProcedureListCubit>().deleteProcedure(
                        widget.procedure.id,
                      );
                    },
                  );
                },
                iconPath: MediaConstants.delete,
                iconColor: const Color(0xFFC0392B),
                backgroundColor: const Color(0xFFFDECEA),
                hoverColor: const Color.fromARGB(255, 255, 159, 148),
                splashColor: context.colors.blackAlpha01,
                borderColor: const Color(0xFFC0392B),
                width: 20,
                height: 20,
                padding: const EdgeInsets.all(9),
                tooltip: 'Elimina procedura',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
