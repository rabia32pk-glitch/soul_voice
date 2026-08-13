import 'package:flutter/material.dart';
import 'package:soul_voice/core/theme/app_themes.dart';
import 'package:soul_voice/screens/splash.dart';

void main() {
  runApp(const SoulVoiceApp());
}

class SoulVoiceApp extends StatefulWidget {
  const SoulVoiceApp({super.key});

  @override
  State<SoulVoiceApp> createState() => _SoulVoiceAppState();
}

class _SoulVoiceAppState extends State<SoulVoiceApp> {
  bool isDarkMode = true;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Soul Voice',

      theme: AppTheme.lightTheme,

      darkTheme: AppTheme.darkTheme,

      themeMode: isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

      home: SplashScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: toggleTheme,
      ),
    );
  }
}