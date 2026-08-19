import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soul_voice/core/theme/app_themes.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/firebase_options.dart';
import 'package:soul_voice/screens/favorite_bloc.dart';
import 'package:soul_voice/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // 👈 MultiBlocProvider lagaya hai taake dono Bloc/Cubit puri app mein milein
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider<FavoriteBloc>(create: (context) => FavoriteBloc()),
      ],
      child: const SoulVoiceApp(),
    ),
  );
}

class SoulVoiceApp extends StatelessWidget {
  const SoulVoiceApp({super.key});

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
          home: const SplashScreen(),
        );
      },
    );
  }
}
