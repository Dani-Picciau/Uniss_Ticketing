import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/ui/components/user_settings/menu_items/settings_menu_item.dart';
import 'package:ticketing_webapp/ui/components/user_settings/menu_items/toggle_menu_item.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/bloc/theme_cubit.dart';
import 'package:ticketing_webapp/ui/components/media_constants.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsMenuItem(
          iconPath: MediaConstants.logout,
          title: 'logout',
          onTap: () {},
        ),
        const SizedBox(height: 5),
        ThemeToggleMenuItem(
          lightIconPath: MediaConstants.lightMode,
          darkIconPath: MediaConstants.darkMode,
          isDarkMode: isDarkMode,
          onTap: () => context.read<ThemeCubit>().toggleTheme(),
        ),
      ],
    );
  }
}
