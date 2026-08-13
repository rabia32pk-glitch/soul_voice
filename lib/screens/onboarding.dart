import 'package:flutter/material.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/screens/auth/login_screens.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const OnboardingScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Discover Knowledge',
      'description':
          'Explore meaningful quotes, Islamic knowledge and inspiring content.',
      'icon': 'auto_awesome',
    },
    {
      'title': 'Learn Your Way',
      'description':
          'Read and explore content in English, Roman Urdu and Punjabi.',
      'icon': 'menu_book',
    },
    {
      'title': 'Learn • Reflect • Grow',
      'description':
          'Take a moment for yourself and discover something meaningful every day.',
      'icon': 'favorite',
    },
  ];

  void _openLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _openLogin();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            // ================= PAGES =================
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,

                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },

                itemBuilder: (context, index) {
                  final page = pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),

                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 180,

                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                // ================= ICON =================
                                Container(
                                  height: 190,
                                  width: 190,

                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,

                                    shape: BoxShape.circle,

                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
                                  ),

                                  child: Icon(
                                    _getIcon(page['icon']!),

                                    size: 80,

                                    color: AppColors.primary,
                                  ),
                                ),

                                const SizedBox(height: 55),

                                // ================= TITLE =================
                                Text(
                                  page['title']!,
                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,

                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 18),

                                // ================= DESCRIPTION =================
                                Text(
                                  page['description']!,
                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.65),

                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ================= DOTS =================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: List.generate(
                pages.length,

                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),

                  margin: const EdgeInsets.symmetric(horizontal: 4),

                  height: 8,

                  width: _currentPage == index ? 28 : 8,

                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.border,

                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ================= CONTINUE =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),

              child: SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: _nextPage,

                  child: Text(
                    _currentPage == pages.length - 1
                        ? 'Get Started'
                        : 'Continue',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ================= SKIP =================
            TextButton(
              onPressed: _openLogin,

              child: Text(
                'Skip',

                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'menu_book':
        return Icons.menu_book_rounded;

      case 'favorite':
        return Icons.favorite_rounded;

      default:
        return Icons.auto_awesome_rounded;
    }
  }
}
