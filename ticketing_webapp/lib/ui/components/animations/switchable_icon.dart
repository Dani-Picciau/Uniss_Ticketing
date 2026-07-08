import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class SwitchableIcon extends StatelessWidget {
  final String firstIconPath;
  final String secondIconPath;
  final bool showFirst; // true = mostra firstIconPath, false = secondIconPath
  final Duration duration;
  final Color? color;

  const SwitchableIcon({
    super.key,
    required this.firstIconPath,
    required this.secondIconPath,
    required this.showFirst,
    this.color,
    this.duration = const Duration(milliseconds: 350),
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? context.colors.gray;

    final currentPath = showFirst ? firstIconPath : secondIconPath;

    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.6),
          end: Offset.zero,
        ).animate(animation);

        return ClipRect(
          child: SlideTransition(
            position: slide,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );
      },
      child: SvgPicture.asset(
        currentPath,
        key: ValueKey(currentPath), // fondamentale per triggerare lo switch
        colorFilter: ColorFilter.mode(resolvedColor, BlendMode.srcIn),
        width: 22,
        height: 22,
      ),
    );
  }
}
