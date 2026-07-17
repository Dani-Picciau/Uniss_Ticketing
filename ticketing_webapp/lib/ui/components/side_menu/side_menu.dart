import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/info_row/info_row.dart';
import 'package:ticketing_webapp/ui/scenes/home_admin_manager/models/sidebar_item_data.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class SideMenu extends StatelessWidget {
  final List<SidebarItemData> items;
  final int selectedIndex;
  final Function(int) onMenuChanged;

  const SideMenu({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onMenuChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: _SideMenuItem(
            item: item,
            currentIndex: selectedIndex,
            onMenuChanged: onMenuChanged,
          ),
        );
      }).toList(),
    );
  }
}

class _SideMenuItem extends StatefulWidget {
  final SidebarItemData item;
  final int currentIndex;
  final Function(int) onMenuChanged;

  const _SideMenuItem({
    required this.item,
    required this.currentIndex,
    required this.onMenuChanged,
  });

  @override
  State<_SideMenuItem> createState() => _SideMenuItemState();
}

class _SideMenuItemState extends State<_SideMenuItem> {
  bool _isHovered = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasSubItems =
        widget.item.subItems != null && widget.item.subItems!.isNotEmpty;

    final isSelected = widget.item.id == widget.currentIndex;
    final isActive = isSelected || _isHovered;

    final contentColor = isActive
        ? context.colors.deepPurple
        : context.colors.black;
    final backgroundColor = isActive
        ? context.colors.deepPurpleAlpha01
        : context.colors.transparent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          // Voce principale del menù
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (hasSubItems) {
                // Se ha sottomenù, apriamo/chiudiamo la tendina senza cambiare schermata
                setState(() => _isExpanded = !_isExpanded);
              } else {
                // Se non ha sottomenù (es. voce figlia o voce singola), notifichiamo il Cubit
                widget.onMenuChanged(widget.item.id);
              }
            },
            child: AnimatedContainer(
              width: double.infinity,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: _isHovered || isActive
                  ? const EdgeInsets.only(left: 24, top: 12, bottom: 12)
                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: InfoRow(
                text: widget.item.title,
                iconPath: widget.item.iconPath,
                textType: UnissTextType.bodySmall,
                color: contentColor,
                iconTurns: (hasSubItems && _isExpanded) ? 0.5 : 0.0,
              ),
            ),
          ),
        ),

        AnimatedSize(
          // Sottomenù a scomparsa
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: (hasSubItems && _isExpanded)
              ? Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.item.subItems!.map((subItem) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: _SideMenuItem(
                          item: subItem,
                          currentIndex: widget.currentIndex,
                          onMenuChanged: widget.onMenuChanged,
                        ),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox(
                  width: double
                      .infinity, // Per prevenire l'effetto di espansione laterale
                  height: 0,
                ),
        ),
      ],
    );
  }
}
