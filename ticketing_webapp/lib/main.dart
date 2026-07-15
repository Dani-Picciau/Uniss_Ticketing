import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_webapp/ui/scenes/login/login_screen.dart';
import 'package:ticketing_webapp/ui/themes/app_theme.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/bloc/theme_cubit.dart';
import 'package:ticketing_webapp/ui/themes/color_themes/bloc/theme_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state.themeMode,
            home: LoginScreen(),
          );
        },
      ),
    );
  }
}
