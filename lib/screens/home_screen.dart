import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/screens/categories_screen.dart';
import 'package:soul_voice/screens/favorite_bloc.dart';
import 'package:soul_voice/screens/favorite_event.dart';
import 'package:soul_voice/screens/favorite_state.dart';
import 'package:soul_voice/screens/notifications_screen.dart';
import 'package:soul_voice/screens/search_screen.dart';
import 'package:soul_voice/services/models/quote_model.dart';
import 'package:soul_voice/services/quote_api_service.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuoteApiService _quoteApiService = QuoteApiService();

  late Future<List<QuoteModel>> _quotesFuture;

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

    // Today's Inspiration Quote Data
    const todayQuoteMap = {
      'quote':
          'Your journey may be difficult, but every step makes you stronger.',
      'author': 'Daily Inspiration',
    };

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
                            '"${todayQuoteMap['quote']}"',
                            style: TextStyle(
                              color: primaryTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            todayQuoteMap['author']!,
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 14),
                         Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, favState) {
        final isTodayFav = favState.favoriteQuotes.any(
          (q) => q['quote'] == todayQuoteMap['quote'],
        );

        return Row(
          children: [
            // ❤️ FAVORITE
            IconButton(
              onPressed: () {
                context.read<FavoriteBloc>().add(
                  ToggleFavoriteEvent(todayQuoteMap),
                );

                ScaffoldMessenger.of(context).clearSnackBars();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isTodayFav
                          ? 'Quote removed from favorites 💔'
                          : 'Quote added to favorites ❤️',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              icon: Icon(
                isTodayFav
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: isTodayFav
                    ? Colors.red
                    : AppColors.primary,
              ),
            ),

            // 📋 COPY
            IconButton(
              onPressed: () async {
                final text =
                    '"${todayQuoteMap['quote']}"\n— ${todayQuoteMap['author']}';

                await Clipboard.setData(
                  ClipboardData(text: text),
                );

                ScaffoldMessenger.of(context).clearSnackBars();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Quote copied successfully 📋',
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: Icon(
                Icons.copy_rounded,
                color: secondaryTextColor,
              ),
            ),

            // ↗️ SHARE
            IconButton(
              onPressed: () {
                final shareText =
                    '"${todayQuoteMap['quote']}"\n— ${todayQuoteMap['author']}';

                Share.share(shareText);
              },
              icon: Icon(
                Icons.share_outlined,
                color: secondaryTextColor,
              ),
            ),
          ],
        );
      },
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
    super.key,
    required this.quote,
    required this.author,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final quoteMap = {
      'quote': quote,
      'author': author,
    };

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
                  style: TextStyle(color: secondaryTextColor, fontSize: 12),
                ),
              ],
            ),
          ),
         BlocBuilder<FavoriteBloc, FavoriteState>(
  builder: (context, favState) {
    final isFav = favState.favoriteQuotes.any(
      (q) => q['quote'] == quote,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ❤️ FAVORITE
        IconButton(
          onPressed: () {
            context.read<FavoriteBloc>().add(
              ToggleFavoriteEvent(quoteMap),
            );

            ScaffoldMessenger.of(context).clearSnackBars();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isFav
                      ? 'Removed from favorites 💔'
                      : 'Quote added to favorites ❤️',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          icon: Icon(
            isFav
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: isFav ? Colors.red : secondaryTextColor,
          ),
        ),

        // 📋 COPY
        IconButton(
          onPressed: () async {
            final text = '"$quote"\n— $author';

            await Clipboard.setData(
              ClipboardData(text: text),
            );

            ScaffoldMessenger.of(context).clearSnackBars();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Quote copied successfully 📋'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          icon: Icon(
            Icons.copy_rounded,
            color: secondaryTextColor,
          ),
        ),

        // ↗️ SHARE
        IconButton(
          onPressed: () {
            final shareText = '"$quote"\n— $author';

            Share.share(shareText);
          },
          icon: Icon(
            Icons.share_outlined,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  },
),
        ],
      ),
    );
  }
}