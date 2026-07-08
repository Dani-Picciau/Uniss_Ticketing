import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void toggleTheme() {
    final newMode = state.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: newMode));
  }

  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }
}
