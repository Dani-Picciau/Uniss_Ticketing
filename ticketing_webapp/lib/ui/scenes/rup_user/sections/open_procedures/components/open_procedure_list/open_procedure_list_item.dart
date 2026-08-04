import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
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
      color: context.colors.transparent,

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
              ? const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12)
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? context.colors.blackAlpha01
                : const Color(0xFFFAF9F6),
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
                    ),
                    const SizedBox(height: 4),
                    UnissLabel(
                      text: 'Fase attuale: ${widget.procedure.currentNodeId}',
                      textType: UnissTextType.bodySmall,
                      color: context.colors.gray,
                    ),
                  ],
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
