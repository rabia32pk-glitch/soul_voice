import 'package:flutter/material.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/screens/categories_screen.dart'; // 👈 Categories screen import ki hai
import 'package:soul_voice/screens/favourite_screens.dart';
import 'package:soul_voice/screens/home_screen.dart';
import 'package:soul_voice/screens/profile_screen.dart';

class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({super.key});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _currentIndex = 0;

  // Bottom Navigation ki saari main screens (QuoteScreen ki jagah CategoriesScreen lagai hai)
  final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(), // 👈 Yahan Categories Screen add ho gayi
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Current theme check karne ke liye
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light aur Dark mode ke hisaab se colors define kiye hain
    final navBackgroundColor = isDark ? AppColors.surface : Colors.white;
    final unselectedColor = isDark
        ? AppColors.textSecondary
        : Colors.grey.shade600;
    final borderColor = isDark ? AppColors.border : const Color(0xFFE0E0E0);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: borderColor, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: navBackgroundColor,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: unselectedColor,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.grid_view_rounded,
              ), // 👈 Categories ke liye Grid Icon
              label: 'Categories', // 👈 Label Change
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
