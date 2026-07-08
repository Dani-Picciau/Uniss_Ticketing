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
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _SideMenuItem(
            title: items[i].title,
            iconPath: items[i].iconPath,
            index: i,
            currentIndex: selectedIndex,
            onTap: () => onMenuChanged(i),
          ),
          if (i != items.length - 1) const SizedBox(height: 5),
        ],
      ],
    );
  }
}

class _SideMenuItem extends StatefulWidget {
  final String title;
  final String iconPath;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _SideMenuItem({
    required this.title,
    required this.iconPath,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<_SideMenuItem> createState() => _SideMenuItemState();
}

class _SideMenuItemState extends State<_SideMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.index == widget.currentIndex;
    final isActive = isSelected || _isHovered;

    final contentColor = isActive ? context.colors.deepPurple : context.colors.black;
    final backgroundColor = isActive
        ? context.colors.deepPurpleAlpha01
        : context.colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          width: double.infinity,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: _isHovered || isActive
              ? EdgeInsets.only(left: 24, top: 12, bottom: 12)
              : EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: InfoRow(
            text: widget.title,
            iconPath: widget.iconPath,
            textType: UnissTextType.bodySmall,
            color: contentColor,
          ),
        ),
      ),
    );
  }
}
