import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/scenes/rup_user/sections/open_procedures/components/open_procedure_list/models/requests/procedure_summary/procedure_summary.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

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
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? context.colors.blackAlpha01 : null,
            borderRadius: BorderRadius.circular(8),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.procedure.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fase attuale: ${widget.procedure.currentNodeId}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
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
                ),
                child: Text(
                  widget.procedure.status,
                  style: TextStyle(
                    color: widget.procedure.status == 'COMPLETATA'
                        ? Colors.green.shade800
                        : Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
