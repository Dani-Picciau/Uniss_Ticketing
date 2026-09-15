import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; // <-- Aggiunto per renderizzare solo l'icona
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

  // L'allineamento ora è SEMPRE orizzontale (asse X)
  Alignment _getAlignment() {
    if (items.length <= 1) return const Alignment(0.0, 0.0);

    final double stepSize = 2.0 / (items.length - 1);
    final double position = -1.0 + (selectedIndex * stepSize);

    return Alignment(position, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1000;

        final menuWidgetItems = items.asMap().entries.map((entry) {
          return _buildMenuItem(
            context: context,
            index: entry.key,
            text: entry.value.text,
            iconPath: entry.value.iconPath,
            isDesktop:
                isDesktop, // <-- Passiamo il flag per capire se mostrare il testo
          );
        }).toList();

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            height: 60, // L'altezza ora è sempre fissa a 60
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: context.colors.whiteAlpha025,
              border: Border.all(color: context.colors.whiteAlpha035),
              borderRadius: BorderRadius.circular(
                50,
              ), // Sempre a forma di pillola
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutQuart,
                  alignment: _getAlignment(),
                  child: FractionallySizedBox(
                    widthFactor:
                        1 / items.length, // Frazione sempre orizzontale
                    heightFactor: 1.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: context.colors.whiteAlpha07,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),

                // Disposizione sempre in orizzontale
                Row(children: menuWidgetItems),
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
    required bool isDesktop,
  }) {
    final isSelected = selectedIndex == index;
    final itemColor = isSelected ? context.colors.black : context.colors.gray;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onMenuChanged(index),
        child: Center(
          child: isDesktop
              ? InfoRow(
                  // Su Desktop usiamo la tua riga classica con icona e testo
                  text: text,
                  iconPath: iconPath,
                  textType: UnissTextType.bodyMedium,
                  color: itemColor,
                )
              : Tooltip(
                  // Su Mobile usiamo solo l'icona + Tooltip
                  message: text,
                  child: SvgPicture.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(itemColor, BlendMode.srcIn),
                  ),
                ),
        ),
      ),
    );
  }
}
