import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences prefs;

  ThemeCubit(this.prefs) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeModeString = prefs.getString(AppConstants.keyThemeMode);
    if (themeModeString != null) {
      switch (themeModeString) {
        case 'light':
          emit(ThemeMode.light);
          break;
        case 'dark':
          emit(ThemeMode.dark);
          break;
        default:
          emit(ThemeMode.system);
      }
    }
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    await prefs.setString(
      AppConstants.keyThemeMode,
      themeMode == ThemeMode.light
          ? 'light'
          : themeMode == ThemeMode.dark
          ? 'dark'
          : 'system',
    );
    emit(themeMode);
  }

  bool get isDarkMode => state == ThemeMode.dark;
  bool get isLightMode => state == ThemeMode.light;
  bool get isSystemMode => state == ThemeMode.system;
}
