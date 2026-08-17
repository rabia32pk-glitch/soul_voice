import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/screens/categories_screen.dart';
import 'package:soul_voice/screens/notifications_screen.dart';
import 'package:soul_voice/screens/search_screen.dart';
import 'package:soul_voice/services/models/quote_model.dart';

import '../services/quote_api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
   
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuoteApiService _quoteApiService = QuoteApiService();

  late Future<List<QuoteModel>> _quotesFuture;
    bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  void _loadQuotes() {
    _quotesFuture = _quoteApiService.getQuotes();
  }

  Future<void> _refreshQuotes() async {
    setState(() {
      _loadQuotes();
    });

    await _quotesFuture;
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Faith', 'icon': Icons.auto_awesome_rounded, 'tag': 'faith'},
      {'name': 'Life', 'icon': Icons.wb_sunny_outlined, 'tag': 'life'},
      {
        'name': 'Wisdom',
        'icon': Icons.lightbulb_outline_rounded,
        'tag': 'wisdom',
      },
      {'name': 'Success', 'icon': Icons.trending_up_rounded, 'tag': 'success'},
      {'name': 'Love', 'icon': Icons.favorite_border_rounded, 'tag': 'love'},
      {'name': 'Peace', 'icon': Icons.spa_outlined, 'tag': 'peace'},
    ];

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

        final backgroundColor = isDark ? AppColors.background : Colors.white;
        final surfaceColor =
            isDark ? AppColors.surface : const Color(0xFFF7F7F7);
        final primaryTextColor =
            isDark ? AppColors.textPrimary : Colors.black87;
        final secondaryTextColor =
            isDark ? AppColors.textSecondary : Colors.black54;
        final borderColor =
            isDark ? AppColors.border : const Color(0xFFE0E0E0);

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refreshQuotes,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= HEADER =================
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assalam-o-Alaikum 👋',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Welcome to Soul Voice',
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Notification
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NotificationsScreen(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.notifications_none_rounded,
                              color: primaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // ================= SEARCH =================
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              color: secondaryTextColor,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Search quotes...',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ================= CATEGORIES =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CategoriesScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'See All',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 105,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final category = categories[index];

                          return _CategoryCard(
                            name: category['name'] as String,
                            icon: category['icon'] as IconData,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                            textColor: primaryTextColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CategoryQuotesScreen(
                                    category: category['tag'] as String,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ================= DAILY QUOTE =================
                    Text(
                      'Daily Quote',
                      const Text(
                        '"Your journey may be difficult, '
                        'but every step makes you stronger."',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'Daily Inspiration',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                        onPressed: () {
  setState(() {
    isFavorite = !isFavorite;
  });
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        isFavorite
            ? 'Your quote has been added to favorites ❤️'
            : 'Your quote has been removed from favorites 💔',
      ),
      duration: Duration(seconds: 2),
    ),
  );
},
icon: Icon(
  isFavorite ? Icons.favorite : Icons.favorite_border,
  color: isFavorite ? Colors.red : AppColors.primary
),
),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ================= FEATURED QUOTES =================

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Quotes',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Today's Inspiration",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          Text(
                            '"Your journey may be difficult, '
                            'but every step makes you stronger."',
                            style: TextStyle(
                              color: primaryTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text(
                            'Daily Inspiration',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 14),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.share_outlined,
                                  color: secondaryTextColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.favorite_border_rounded,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ================= FEATURED QUOTES =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Featured Quotes',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _loadQuotes();
                            });
                          },
                          icon: const Icon(
                            Icons.refresh_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // ================= API QUOTES =================
                    FutureBuilder<List<QuoteModel>>(
                      future: _quotesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(35),
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.cloud_off_rounded,
                                  color: AppColors.primary,
                                  size: 40,
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  'Unable to load quotes',
                                  style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  'Please check your internet '
                                  'connection and try again.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 13,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _loadQuotes();
                                    });
                                  },
                                  child: const Text('Try Again'),
                                ),
                              ],
                            ),
                          );
                        }

                        final quotes = snapshot.data ?? [];

                        if (quotes.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(25),
                            child: Text(
                              'No quotes found.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: secondaryTextColor),
                            ),
                          );
                        }

                        return Column(
                          children: quotes
                              .take(5)
                              .map(
                                (quote) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _QuoteCard(
                                    quote: quote.content,
                                    author: quote.author,
                                    surfaceColor: surfaceColor,
                                    borderColor: borderColor,
                                    primaryTextColor: primaryTextColor,
                                    secondaryTextColor: secondaryTextColor,
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}

// =====================================================
// CATEGORY CARD
// =====================================================

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color surfaceColor;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.surfaceColor,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 10),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// QUOTE CARD
// =====================================================

class _QuoteCard extends StatelessWidget {
  final String quote;
  final String author;
  final Color surfaceColor;
  final Color borderColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  const _QuoteCard({
    required this.quote,
    required this.author,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote_rounded,
            color: AppColors.primary,
            size: 30,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '— $author',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.favorite_border_rounded,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}