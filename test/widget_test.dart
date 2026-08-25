import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_voice/main.dart';
import 'package:soul_voice/screens/splash.dart';
import 'package:soul_voice/screens/main_wrapper_screen.dart';
import 'package:soul_voice/screens/home_screen.dart';
import 'package:soul_voice/screens/categories_screen.dart';
import 'package:soul_voice/screens/favourite_screens.dart';
import 'package:soul_voice/screens/settings_screen.dart';
import 'package:soul_voice/screens/search_screen.dart';
import 'package:soul_voice/screens/about_soul_voice_screen.dart';
import 'package:soul_voice/screens/heplsupportscreen.dart';
import 'package:soul_voice/screens/privacy_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App opens cleanly with Splash screen and transitions to MainWrapperScreen without crash',
      (WidgetTester tester) async {
    // 1. Launch App
    await tester.pumpWidget(const SoulVoiceApp());

    // Verify SplashScreen is displayed initially
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('Soul Voice'), findsWidgets);
    expect(find.text('Your voice, your thoughts, your soul.'), findsOneWidget);

    // 2. Advance time past splash delay (2 seconds)
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify MainWrapperScreen and HomeScreen are loaded
    expect(find.byType(MainWrapperScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Assalam-o-Alaikum 👋'), findsOneWidget);
    expect(find.text('Welcome to Soul Voice'), findsOneWidget);
    expect(find.text("Today's Inspiration"), findsOneWidget);
  });

  testWidgets('App bottom navigation tabs and sub-screens render without crash',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const SoulVoiceApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Verify tabs
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // 1. Switch to Categories tab (Index 1)
    await tester.tap(find.text('Categories').last);
    await tester.pumpAndSettle();
    expect(find.byType(CategoriesScreen), findsOneWidget);
    expect(find.text('Explore Quotes'), findsOneWidget);

    // 2. Switch to Favorites tab (Index 2)
    await tester.tap(find.text('Favorites').last);
    await tester.pumpAndSettle();
    expect(find.byType(FavoritesScreen), findsOneWidget);
    expect(find.text('No favorites added yet'), findsOneWidget);

    // 3. Switch to Settings tab (Index 3)
    await tester.tap(find.text('Settings').last);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Dark Theme'), findsOneWidget);
    expect(find.text('Help & Support'), findsOneWidget);

    // 4. Open Help & Support
    await tester.tap(find.text('Help & Support'));
    await tester.pumpAndSettle();
    expect(find.byType(HelpSupportScreen), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // 5. Open Privacy Policy
    await tester.tap(find.text('Privacy Policy'));
    await tester.pumpAndSettle();
    expect(find.byType(PrivacyScreen), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // 6. Open About Soul Voice
    await tester.tap(find.text('About Soul Voice'));
    await tester.pumpAndSettle();
    expect(find.byType(AboutSoulVoiceScreen), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // 7. Go back to Home tab and open Search
    await tester.tap(find.text('Home').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Search quotes...'));
    await tester.pumpAndSettle();
    expect(find.byType(SearchScreen), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
  });
}
