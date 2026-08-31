import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/animations/rotate_in.dart';
import 'package:ticketing_webapp/ui/components/overlay_confirm_message/uniss_dialogs.dart.dart';

import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/uniss_buttons/uniss_icon_button.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/bloc/procedure_list_cubit.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/components/open_procedure_list/deadline_badge.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/components/open_procedure_list/status_badge.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/models/requests/procedure_summary/procedure_summary.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class OpenProcedureListItem extends StatefulWidget {
  final ProcedureSummary procedure;
  final VoidCallback onTap;

  final bool showReassignButton;
  final bool showDeleteButton;
  final bool showDeadline;
  final bool showArrowAnimation;

  const OpenProcedureListItem({
    super.key,
    required this.procedure,
    required this.onTap,
    this.showReassignButton = true,
    this.showDeleteButton = true,
    this.showArrowAnimation = true,
    this.showDeadline = false,
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
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: _isHovered
              ? EdgeInsets.only(
                  left: 30,
                  right: widget.showDeadline ? 30 : 16,
                  top: 12,
                  bottom: 12,
                )
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? context.colors.blackAlpha01 : null,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.colors.lightGray),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.showArrowAnimation) ...[
                _isHovered
                    ? FadeIn(
                        duration: const Duration(milliseconds: 400),
                        offset: Offset(-50, 0),
                        child: RotateIn(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.colors.whiteAlpha07,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: context.colors.blackAlpha01,
                              ),
                            ),
                            child: SvgPicture.asset(
                              MediaConstants.arrowRight,
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),

                SizedBox(width: _isHovered ? 16 : 0),
              ],

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

              if (widget.showDeadline) ...[
                DeadlineBadge(deadline: widget.procedure.deadline),
                SizedBox(width: 8),
              ],

              StatusBadge(status: widget.procedure.status),

              if (widget.showReassignButton) ...[
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
                          'Sei sicuro di voler eliminare questa procedura?',
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
                  iconWidth: 20,
                  iconHeight: 20,
                  padding: const EdgeInsets.all(9),
                  tooltip: 'Elimina procedura',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
