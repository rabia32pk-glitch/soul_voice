import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  // Default Initial Theme Dark set kar di hai
  ThemeCubit() : super(ThemeMode.dark) {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode');

    if (isDark != null) {
      // Agar user ne pehle se light/dark toggle kiya hai to wo setting load hogi
      emit(isDark ? ThemeMode.dark : ThemeMode.light);
    } else {
      // Pehli baar open karne par default Dark Mode hi emit hoga
      emit(ThemeMode.dark);
    }
  }

  void toggleTheme() async {
    setTheme(state != ThemeMode.dark);
  }

  void setTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
    await prefs.setBool('isDarkMode', isDark);
  }
}
