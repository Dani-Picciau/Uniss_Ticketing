import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/info_row/info_row.dart';
import 'package:ticketing_webapp/ui/components/sliding_menu/sliding_menu_item.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class SlidingMenu extends StatelessWidget {
  final int selectedIndex;
  final List<SlidingMenuItem> items;
  final Function(int) onMenuChanged;

  const SlidingMenu({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onMenuChanged,
  });

  Alignment _getAlignment(bool isDesktop) {
    // Gestione di un solo elemento
    if (items.length <= 1) return const Alignment(0.0, 0.0);

    // Calcolo dinamico: la distanza totale da -1 a 1 è 2.
    // Dividiamo 2 per il numero di "salti" possibili (items.length - 1)
    final double stepSize = 2.0 / (items.length - 1);
    final double position = -1.0 + (selectedIndex * stepSize);

    return isDesktop ? Alignment(position, 0.0) : Alignment(0.0, position);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Usiamo lo stesso breakpoint della pagina principale
        final isDesktop = constraints.maxWidth > 800;

        // Trasformiamo la nostra lista di dati in widget
        final menuWidgetItems = items.asMap().entries.map((entry) {
          return _buildMenuItem(
            context: context,
            index: entry.key,
            text: entry.value.text,
            iconPath: entry.value.iconPath,
          );
        }).toList();

        // Calcoliamo l'altezza mobile dinamicamente (es. 40 pixel per ogni voce)
        final double mobileHeight = (items.length * 40.0) + 12.0;

        return MouseRegion(
          cursor: SystemMouseCursors.click, // Fa apparire la manina del cursore
          child: Container(
            height: isDesktop ? 60 : mobileHeight,
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
                    widthFactor: isDesktop ? 1 / items.length : 1.0,
                    heightFactor: isDesktop ? 1.0 : 1.0 / items.length,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
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
                    ? Row(children: menuWidgetItems) // Disposti in orizzontale
                    : Column(
                        children: menuWidgetItems,
                      ), // Disposti in verticale
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required int index,
    required String text,
    required String iconPath,
  }) {
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
