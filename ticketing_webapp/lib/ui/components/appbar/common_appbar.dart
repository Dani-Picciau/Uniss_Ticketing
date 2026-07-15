import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:ticketing_webapp/ui/components/label/uniss_label.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';
import 'package:ticketing_webapp/ui/components/user_settings/overlay_menu.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/color_palette.dart';
import 'package:ticketing_webapp/ui/themes/text_themes/uniss_text_theme.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String initials;
  const CommonAppbar({super.key, required this.userName, required this.initials});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leadingWidth: 300,
      //Element on the left
      leading: Row(
        children: [
          SizedBox(width: 16),
          //SvgPicture.asset(MediaConstants.dipLogo),
        ],
      ),

      //Elements on the right
      actions: [
        UnissLabel(text: userName, textType: UnissTextType.bodyMedium),
        SizedBox(width: 10),
        OverlayMenu(iconPath: MediaConstants.userInfo),
        SizedBox(width: 10),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: context.colors.profileBackground,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: context.colors.black),
          ),
          child: Center(
            child: UnissLabel(text: initials, textType: UnissTextType.bodySmall),
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}
