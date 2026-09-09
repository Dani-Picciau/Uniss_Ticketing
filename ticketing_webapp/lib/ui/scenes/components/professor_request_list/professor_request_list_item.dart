import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/ui/components/overlay_confirm_message/uniss_dialogs.dart.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/uniss_buttons/uniss_icon_button.dart';
import 'package:ticketing_webapp/ui/components/item_list_badge/status_badge.dart';
import 'package:ticketing_webapp/ui/scenes/models/ui_models/professor_request_ui_model.dart';
import 'package:ticketing_webapp/ui/scenes/professor_user/sections/pending_requests/bloc/pending_requests_cubit.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';
import 'package:intl/intl.dart';

class ProfessorRequestListItem extends StatefulWidget {
  final ProfessorRequestUiModel request;
  final bool showDeleteButton;
  final bool showReassignButton;

  const ProfessorRequestListItem({
    super.key,
    required this.request,
    this.showDeleteButton = false,
    this.showReassignButton = false,
  });

  @override
  State<ProfessorRequestListItem> createState() =>
      _ProfessorRequestListItemState();
}

class _ProfessorRequestListItemState extends State<ProfessorRequestListItem> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final String dataFormattata = DateFormat(
      "dd/MM/yyyy 'alle' HH:mm",
    ).format(widget.request.createdAt.toLocal());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.lightGray),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UnissLabel(
                      text: widget.request.subject,
                      textType: UnissTextType.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      isSelectable: true,
                    ),
                    const SizedBox(height: 4),
                    UnissLabel(
                      text: widget.request.requestingProfessorName,
                      textType: UnissTextType.bodySmall,
                      color: context.colors.gray,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      isSelectable: true,
                    ),
                  ],
                ),
              ),

              SizedBox(width: 50),

              StatusBadge(status: widget.request.status),

              if (widget.showReassignButton) ...[
                SizedBox(width: 8),
                UnissIconButton(
                  onTap: () {
                    UnissDialogs.showConfirmation(
                      context,
                      message: 'Riasegnazione della procedura',
                      confirmText: 'Riassegna',
                      onConfirm: () {
                        // Metodo di riassegnazione
                      },
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
                  iconWidth: 20,
                  iconHeight: 20,
                  padding: const EdgeInsets.all(9),
                  tooltip: 'Riassegna procedura',
                ),
              ],

              if (widget.showDeleteButton) ...[
                SizedBox(width: 8),

                UnissIconButton(
                  onTap: () {
                    UnissDialogs.showConfirmation(
                      context,
                      message:
                          'Sei sicuro di voler eliminare questa richiesta?',
                      confirmText: 'Elimina',
                      onConfirm: () {
                        context.read<PendingRequestsCubit>().deleteRequest(
                          widget.request.id,
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
                  iconWidth: 20,
                  iconHeight: 20,
                  padding: const EdgeInsets.all(9),
                  tooltip: 'Elimina procedura',
                ),
              ],

              const SizedBox(width: 16),
              UnissIconButton(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                iconPath: MediaConstants.arrowDown,
                iconTurns: _isExpanded ? 0.5 : 0.0,
                backgroundColor: context.colors.deepPurpleAlpha01,
                iconColor: context.colors.deepPurple,
                borderColor: context.colors.deepPurple,
                hoverColor: const Color.fromARGB(255, 233, 203, 252),
                padding: EdgeInsets.all(4),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _isExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: context.colors.lightGray),

                      const SizedBox(height: 5),

                      // Dettagli della procedura
                      UnissLabel(
                        text: 'Corpo della richiesta: ',
                        textType: UnissTextType.bodySmall,

                        spanText: widget.request.content,
                        spanTextType: UnissTextType.bodySmall,
                        spanColor: context.colors.gray,
                        isSelectable: true,
                        
                      ),

                      const SizedBox(height: 5),

                      UnissLabel(
                        text: 'Data creazione: ',
                        textType: UnissTextType.bodySmall,

                        spanText: dataFormattata,
                        spanTextType: UnissTextType.bodySmall,
                        spanColor: context.colors.gray,
                        isSelectable: true,
                      ),
                    ],
                  )
                : const SizedBox.shrink(), // Se è chiuso, lo nascondiamo (0 pixel)
          ),
        ],
      ),
    );
  }
}
