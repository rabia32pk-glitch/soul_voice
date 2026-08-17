
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soul_voice/core/theme/app_themes.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/firebase_options.dart';
import 'package:soul_voice/screens/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const SoulVoiceApp());
}

class SoulVoiceApp extends StatelessWidget {
  const SoulVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),

      child: const SoulVoiceAppView(),
    );
  }
}

class SoulVoiceAppView extends StatelessWidget {
  const SoulVoiceAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Soul Voice',

theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          themeMode: themeMode,

          home: SplashScreen(
            isDarkMode: themeMode == ThemeMode.dark,
            onThemeChanged: (isDark) {
              context.read<ThemeCubit>().setTheme(isDark);
            },
          ),

        );
      },
    );
  }
}
