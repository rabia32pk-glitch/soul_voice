import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

<<<<<<< HEAD
=======
import 'package:soul_voice/core/theme/app_themes.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/screens/splash.dart';

>>>>>>> 9fbd5868950daff0d0a8ef991bb084d0c0dc129a
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
<<<<<<< HEAD
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
=======
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Soul Voice',

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,

            home: const SplashScreen(),
          );
        },
>>>>>>> 9fbd5868950daff0d0a8ef991bb084d0c0dc129a
      ),
    );
  }
}