import 'package:flutter/material.dart';
import 'package:ticketing_webapp/ui/components/animations/fade_in.dart';
import 'package:ticketing_webapp/ui/components/user_settings/settings_button.dart';
import 'package:ticketing_webapp/ui/components/user_settings/settings_menu.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';

class OverlayMenu extends StatefulWidget {
  final String iconPath;

  const OverlayMenu({super.key, required this.iconPath});

  @override
  State<OverlayMenu> createState() => _OverlayMenuState();
}

class _OverlayMenuState extends State<OverlayMenu> {
  final GlobalKey _triggerKey = GlobalKey();
  final GlobalKey _panelKey = GlobalKey();

  OverlayEntry? _overlayEntry;

  bool get _isOpen => _overlayEntry != null;

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: _handleOutsideTap,
            ),
          ),
          Positioned(
            top: 50,
            right: 65,
            child: Material(
              color: context.colors.transparent,
              child: FadeIn(
                offset: const Offset(-50, 0),
                child: Container(
                  width: 180,
                  key: _panelKey,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.warmPaper,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.blackAlpha015,
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SettingsMenu(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(
      () {},
    ); // per aggiornare eventuali indicatori visivi (es. freccia ruotata)
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  // Vero solo se il punto (in coordinate globali) cade dentro i confini
  // reali del widget identificato da `key`.
  bool _isInsideBounds(GlobalKey key, Offset globalPosition) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return false;

    final localPosition = renderBox.globalToLocal(globalPosition);
    final bounds = Offset.zero & renderBox.size;
    return bounds.contains(localPosition);
  }

  void _handleOutsideTap(PointerDownEvent event) {
    final isInsidePanel = _isInsideBounds(_panelKey, event.position);
    final isOnTrigger = _isInsideBounds(_triggerKey, event.position);

    // Sul pannello: non facciamo nulla, i suoi contenuti gestiscono se stessi.
    // Sul bottone: non facciamo nulla qui, ci pensa il suo onTap (_toggle).
    // Altrove: chiudiamo.
    if (!isInsidePanel && !isOnTrigger) {
      _close();
    }
  }

  @override
  void dispose() {
    // Rete di sicurezza: se il widget viene distrutto mentre il pannello
    // è ancora aperto, evitiamo di lasciarlo "appeso" nell'Overlay.
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsButton(
      key: _triggerKey,
      iconPath: widget.iconPath,
      onTap: _toggle,
    );
  }
}
