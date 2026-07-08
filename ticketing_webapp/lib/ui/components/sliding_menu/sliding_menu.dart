import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/info_row/info_row.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class SlidingMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onMenuChanged;

  const SlidingMenu({
    super.key,
    required this.selectedIndex,
    required this.onMenuChanged,
  });

  Alignment _getAlignment(bool isDesktop) {
    final double position = -1.0 + (selectedIndex * (2 / 3));

    if (isDesktop) {
      return Alignment(position, 0.0);
    } else {
      return Alignment(0.0, position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Usiamo lo stesso breakpoint della pagina principale
        final isDesktop = constraints.maxWidth > 800;

        // I tre pulsanti (Expanded funziona automaticamente sia in Row che in Column!)
        final menuItems = [
          _buildMenuItem(context, 0, 'Scadenze', MediaConstants.scadenze),
          _buildMenuItem(context, 1, 'Alla firma', MediaConstants.signature),
          _buildMenuItem(
            context,
            2,
            'Procedure aperte',
            MediaConstants.openProcedure,
          ),
          _buildMenuItem(
            context,
            3,
            'Nuova procedura',
            MediaConstants.newProcedure,
          ),
        ];

        return MouseRegion(
          cursor: SystemMouseCursors.click, // Fa apparire la manina del cursore
          child: Container(
            // Se orizzontale alto 50, se verticale alto 150 (50 per ogni riga)
            height: isDesktop ? 60 : 200,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: context.colors.whiteAlpha025,
              border: Border.all(color: context.colors.whiteAlpha035),
              // Riduciamo il raggio del bordo su mobile per non farlo sembrare una pillola gigante
              borderRadius: BorderRadius.circular(isDesktop ? 50 : 16),
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutQuart,
                  alignment: _getAlignment(isDesktop),
                  child: FractionallySizedBox(
                    widthFactor: isDesktop ? 1 / 4 : 1.0,
                    heightFactor: isDesktop ? 1.0 : 1 / 4,
                    child: Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: context.colors.whiteAlpha07,
                        borderRadius: BorderRadius.circular(
                          isDesktop ? 50 : 16,
                        ),
                      ),
                    ),
                  ),
                ),

                isDesktop
                    ? Row(children: menuItems) // Disposti in orizzontale
                    : Column(children: menuItems), // Disposti in verticale
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    int index,
    String text,
    String iconPath,
  ) {
    final isSelected = selectedIndex == index;
    final itemColor = isSelected ? context.colors.black : context.colors.gray;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onMenuChanged(index),
        child: Center(
          child: InfoRow(
            text: text,
            iconPath: iconPath,
            textType: UnissTextType.bodyMedium,
            color: itemColor,
          ),
        ),
      ),
    );
  }
}
