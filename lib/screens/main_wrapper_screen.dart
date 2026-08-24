import 'package:flutter/material.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/screens/categories_screen.dart';
import 'package:soul_voice/screens/favourite_screens.dart';
import 'package:soul_voice/screens/home_screen.dart';
import 'package:soul_voice/screens/profile_screen.dart';

class MainWrapperScreen extends StatefulWidget {
  final int initialIndex;

  const MainWrapperScreen({
    super.key,
    this.initialIndex = 0,
  });

  static void switchTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainWrapperScreenState>();
    if (state != null) {
      state.setIndex(index);
    }
  }

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  late int _currentIndex;

  void setIndex(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  late final List<Widget> _screens = [
    HomeScreen(
      onSeeAllCategories: () => setIndex(1),
    ),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    // initialIndex decide karega ke kaunsi screen open hogi
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final navBackgroundColor =
        isDark ? AppColors.surface : Colors.white;

    final unselectedColor =
        isDark ? AppColors.textSecondary : Colors.grey.shade600;

    final borderColor =
        isDark ? AppColors.border : const Color(0xFFE0E0E0);

    return PopScope(
      // Agar Home par hain to app close hone di jayegi
      canPop: _currentIndex == 0,

      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Agar Home ke ilawa kisi tab par hain
        // to back press par Home par aa jayenge
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },

      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: navBackgroundColor,
            border: Border(
              top: BorderSide(
                color: borderColor,
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              backgroundColor: navBackgroundColor,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: unselectedColor,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_rounded,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.grid_view_rounded,
                  ),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite_border_rounded,
                  ),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_outline_rounded,
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}