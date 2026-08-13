import 'package:flutter/material.dart';
import 'package:soul_voice/core/theme/app_themes.dart';
import 'package:soul_voice/screens/splash.dart';


void main() {
  runApp(const SoulVoiceApp());
}

class SoulVoiceApp extends StatelessWidget {
  const SoulVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Soul Voice',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}