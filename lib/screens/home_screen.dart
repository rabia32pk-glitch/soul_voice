import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

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


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuoteApiService _quoteApiService = QuoteApiService();

  late Future<List<QuoteModel>> _quotesFuture;

  // =====================================================
  // CATEGORIES LIST
  // =====================================================
  final List<Map<String, dynamic>> _categories = [
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
    {'name': 'Courage', 'icon': Icons.shield_outlined, 'tag': 'courage'},
    {'name': 'Hope', 'icon': Icons.wb_incandescent_outlined, 'tag': 'hope'},
    {
      'name': 'Patience',
      'icon': Icons.hourglass_empty_rounded,
      'tag': 'patience',
    },
    {
      'name': 'Gratitude',
      'icon': Icons.volunteer_activism_outlined,
      'tag': 'gratitude',
    },
    {
      'name': 'Strength',
      'icon': Icons.fitness_center_rounded,
      'tag': 'strength',
    },
    {
      'name': 'Happiness',
      'icon': Icons.sentiment_very_satisfied_rounded,
      'tag': 'happiness',
    },
    {'name': 'Motivation', 'icon': Icons.bolt_rounded, 'tag': 'motivation'},
    {
      'name': 'Friendship',
      'icon': Icons.people_outline_rounded,
      'tag': 'friendship',
    },
    {
      'name': 'Knowledge',
      'icon': Icons.menu_book_rounded,
      'tag': 'knowledge',
    },
    {'name': 'Kindness', 'icon': Icons.handshake_outlined, 'tag': 'kindness'},
    {'name': 'Time', 'icon': Icons.access_time_rounded, 'tag': 'time'},
    {
      'name': 'Forgiveness',
      'icon': Icons.self_improvement_rounded,
      'tag': 'forgiveness',
    },
    {'name': 'Truth', 'icon': Icons.verified_outlined, 'tag': 'truth'},
    {'name': 'Future', 'icon': Icons.explore_outlined, 'tag': 'future'},
  ];

  // =====================================================
  // DAILY INSPIRATION QUOTES
  // =====================================================

  final List<Map<String, String>> _dailyInspirationQuotes = [
    {
      'quote':
          'Your journey may be difficult, but every step makes you stronger.',
      'author': 'Daily Inspiration',
    },
    {
      'quote':
          'Patience is not the ability to wait, but how you behave while waiting.',
      'author': 'Daily Inspiration',
    },
    {
      'quote': 'Trust the process. Your time and success will definitely come.',
      'author': 'Daily Inspiration',
    },
    {
      'quote':
          'Peace comes from within. Do not seek it outside without inner harmony.',
      'author': 'Daily Inspiration',
    },
    {
      'quote':
          'Every day is a new beginning. Take a deep breath and start again.',
      'author': 'Daily Inspiration',
    },
    {
      'quote': 'Small daily improvements over time lead to stunning results.',
      'author': 'Daily Inspiration',
    },
    {
      'quote': 'Do not lose hope. You never know what tomorrow will bring.',
      'author': 'Daily Inspiration',
    },
    {
      'quote':
          'Believe in yourself and all that you are. There is something greater inside you.',
      'author': 'Daily Inspiration',
    },
    {
      'quote':
          'Kindness is a language which the deaf can hear and the blind can see.',
      'author': 'Daily Inspiration',
    },
    {
      'quote':
          'Hardships often prepare ordinary people for an extraordinary destiny.',
      'author': 'Daily Inspiration',
    },
  ];

  // =====================================================
  // TODAY'S QUOTE
  // =====================================================

  Map<String, String> _getTodayQuote() {
    final now = DateTime.now();

    final dayIndex = now.difference(DateTime(2025, 1, 1)).inDays;

    final index = dayIndex % _dailyInspirationQuotes.length;

    return _dailyInspirationQuotes[index];
  }

  // =====================================================
  // LOAD QUOTES
  // =====================================================

  @override
  void initState() {
    super.initState();
    _categories.shuffle(); // 👈 جب پیج اوپن ہوگا تو کیٹیگریز شفل ہو جائیں گی
    _loadQuotes();
  }

  void _loadQuotes() {
    _quotesFuture = _quoteApiService.getQuotes();
  }

  Future<void> _refreshQuotes() async {
    setState(() {
      _categories.shuffle(); // 👈 جب صارف اوپر سوائپ کر کے ریفریش کرے گا
      _loadQuotes();
    });

    await _quotesFuture;
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final todayQuoteMap = _getTodayQuote();
=======
    final categories = [
      {
        'name': 'Faith',
        'icon': Icons.auto_awesome_rounded,
        'tag': 'faith'
      },
      {
        'name': 'Life',
        'icon': Icons.wb_sunny_outlined,
        'tag': 'life'
      },
      {
        'name': 'Wisdom',
        'icon': Icons.lightbulb_outline_rounded,
        'tag': 'wisdom',
      },
      {
        'name': 'Success',
        'icon': Icons.trending_up_rounded,
        'tag': 'success'
      },
      {
        'name': 'Love',
        'icon': Icons.favorite_border_rounded,
        'tag': 'love'
      },
      {
        'name': 'Peace',
        'icon': Icons.spa_outlined,
        'tag': 'peace'
      },
    ];

    // Today's Inspiration Quote Data
    const todayQuoteMap = {
      'quote':
          'Your journey may be difficult, but every step makes you stronger.',
      'author': 'Daily Inspiration',
    };
>>>>>>> origin/qandeel

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

<<<<<<< HEAD
        final backgroundColor = isDark ? AppColors.background : Colors.white;

        final surfaceColor = isDark
            ? AppColors.surface
            : const Color(0xFFF7F7F7);

        final primaryTextColor = isDark
            ? AppColors.textPrimary
            : Colors.black87;

        final secondaryTextColor = isDark
            ? AppColors.textSecondary
            : Colors.black54;

        final borderColor = isDark ? AppColors.border : const Color(0xFFE0E0E0);
=======
        final backgroundColor =
            isDark ? AppColors.background : Colors.white;
        final surfaceColor =
            isDark ? AppColors.surface : const Color(0xFFF7F7F7);
        final primaryTextColor =
            isDark ? AppColors.textPrimary : Colors.black87;
        final secondaryTextColor =
            isDark ? AppColors.textSecondary : Colors.black54;
        final borderColor =
            isDark ? AppColors.border : const Color(0xFFE0E0E0);
>>>>>>> origin/qandeel

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
<<<<<<< HEAD
                    // =====================================================
                    // HEADER
                    // =====================================================
=======

                    // ================= HEADER =================

>>>>>>> origin/qandeel
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
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

                        Container(
                          height: 45,
                          width: 45,

                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius:
                                BorderRadius.circular(14),
                            border: Border.all(
                              color: borderColor,
                            ),
                          ),

                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const NotificationsScreen(),
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

<<<<<<< HEAD
                    // =====================================================
                    // SEARCH
                    // =====================================================
=======
                    // ================= SEARCH =================

>>>>>>> origin/qandeel
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const SearchScreen(),
                          ),
                        );
                      },

                      child: Container(
                        height: 52,
<<<<<<< HEAD

                        padding: const EdgeInsets.symmetric(horizontal: 16),

=======
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
>>>>>>> origin/qandeel
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius:
                              BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor,
                          ),
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

<<<<<<< HEAD
                    // =====================================================
                    // CATEGORIES
                    // =====================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

=======
                    // ================= CATEGORIES =================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
>>>>>>> origin/qandeel
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
                                builder: (_) =>
                                    const CategoriesScreen(),
                              ),
                            );
                          },

                          child: const Text(
                            'See All',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 105,

                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
<<<<<<< HEAD

                        itemCount: _categories.length,

                        separatorBuilder: (_, _) => const SizedBox(width: 12),

                        itemBuilder: (context, index) {
                          final category = _categories[index];

                          return _CategoryCard(
                            name: category['name'] as String,

                            icon: category['icon'] as IconData,

                            surfaceColor: surfaceColor,

                            borderColor: borderColor,

                            textColor: primaryTextColor,

=======
                        itemCount: categories.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final category =
                              categories[index];

                          return _CategoryCard(
                            name:
                                category['name'] as String,
                            icon:
                                category['icon'] as IconData,
                            surfaceColor:
                                surfaceColor,
                            borderColor:
                                borderColor,
                            textColor:
                                primaryTextColor,
>>>>>>> origin/qandeel
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CategoryQuotesScreen(
                                    category:
                                        category['tag']
                                            as String,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

<<<<<<< HEAD
                    // =====================================================
                    // TODAY'S INSPIRATION
                    // =====================================================
=======
                    // ================= DAILY QUOTE =================

>>>>>>> origin/qandeel
                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(22),

                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius:
                            BorderRadius.circular(22),
                        border: Border.all(
                          color: borderColor,
                        ),
                      ),

                      child: Column(
<<<<<<< HEAD
                        crossAxisAlignment: CrossAxisAlignment.start,

=======
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
>>>>>>> origin/qandeel
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
<<<<<<< HEAD

                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,

                            child: _QuoteActions(
                              quote: todayQuoteMap['quote']!,
                              author: todayQuoteMap['author']!,
                              secondaryTextColor: secondaryTextColor,
                            ),
=======

                          const SizedBox(height: 14),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
                            children: [
                              BlocBuilder<FavoriteBloc,
                                  FavoriteState>(
                                builder:
                                    (context, favState) {
                                  final isTodayFav =
                                      favState.favoriteQuotes
                                          .any(
                                    (q) =>
                                        q['quote'] ==
                                        todayQuoteMap[
                                            'quote'],
                                  );

                                  return IconButton(
                                    onPressed: () {
                                      context
                                          .read<FavoriteBloc>()
                                          .add(
                                            ToggleFavoriteEvent(
                                              todayQuoteMap,
                                            ),
                                          );

                                      ScaffoldMessenger.of(
                                              context)
                                          .clearSnackBars();

                                      ScaffoldMessenger.of(
                                              context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            isTodayFav
                                                ? 'Quote removed from favorites 💔'
                                                : 'Quote added to favorites ❤️',
                                          ),
                                          duration:
                                              const Duration(
                                            seconds: 2,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      isTodayFav
                                          ? Icons.favorite
                                          : Icons
                                              .favorite_border,
                                      color: isTodayFav
                                          ? Colors.red
                                          : AppColors.primary,
                                    ),
                                  );
                                },
                              ),
                            ],
>>>>>>> origin/qandeel
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

<<<<<<< HEAD
                    // =====================================================
                    // FEATURED QUOTES TITLE
                    // =====================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

=======
                    // ================= FEATURED QUOTES =================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
>>>>>>> origin/qandeel
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

<<<<<<< HEAD
                    // =====================================================
                    // API QUOTES
                    // =====================================================
=======
                    // ================= API QUOTES =================

>>>>>>> origin/qandeel
                    FutureBuilder<List<QuoteModel>>(
                      future: _quotesFuture,

                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(35),
                              child:
                                  CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Container(
                            width: double.infinity,
<<<<<<< HEAD

                            padding: const EdgeInsets.all(22),

=======
                            padding:
                                const EdgeInsets.all(22),
>>>>>>> origin/qandeel
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius:
                                  BorderRadius.circular(18),
                              border: Border.all(
                                color: borderColor,
                              ),
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
                                    color:
                                        primaryTextColor,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  'Please check your internet connection and try again.',
<<<<<<< HEAD
                                  textAlign: TextAlign.center,
=======
                                  textAlign:
                                      TextAlign.center,
>>>>>>> origin/qandeel
                                  style: TextStyle(
                                    color:
                                        secondaryTextColor,
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
<<<<<<< HEAD

                                  child: const Text('Try Again'),
=======
                                  child:
                                      const Text('Try Again'),
>>>>>>> origin/qandeel
                                ),
                              ],
                            ),
                          );
                        }

                        final quotes =
                            snapshot.data ?? [];

                        if (quotes.isEmpty) {
                          return Container(
                            width: double.infinity,
<<<<<<< HEAD

                            padding: const EdgeInsets.all(25),

=======
                            padding:
                                const EdgeInsets.all(25),
>>>>>>> origin/qandeel
                            child: Text(
                              'No quotes found.',
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                color:
                                    secondaryTextColor,
                              ),
                            ),
                          );
                        }

                        // ================= UNLIMITED FEATURED QUOTES =================

                        return Column(
<<<<<<< HEAD
                          children: quotes.map((quote) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),

                              child: _QuoteCard(
                                quote: quote.content,
                                author: quote.author,
                                surfaceColor: surfaceColor,
                                borderColor: borderColor,
                                primaryTextColor: primaryTextColor,
                                secondaryTextColor: secondaryTextColor,
                              ),
                            );
                          }).toList(),
=======
                          children: quotes
                              .map(
                                (quote) => Padding(
                                  padding:
                                      const EdgeInsets.only(
                                    bottom: 12,
                                  ),
                                  child: _QuoteCard(
                                    quote: quote.content,
                                    author: quote.author,
                                    surfaceColor:
                                        surfaceColor,
                                    borderColor:
                                        borderColor,
                                    primaryTextColor:
                                        primaryTextColor,
                                    secondaryTextColor:
                                        secondaryTextColor,
                                  ),
                                ),
                              )
                              .toList(),
>>>>>>> origin/qandeel
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
          border: Border.all(
            color: borderColor,
          ),
        ),

        child: Column(
<<<<<<< HEAD
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, color: AppColors.primary, size: 28),

=======
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 28,
            ),
>>>>>>> origin/qandeel
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
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
        ),
      ),
<<<<<<< HEAD

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
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
=======
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote_rounded,
            color: AppColors.primary,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, favState) {
              final isFav =
                  favState.favoriteQuotes.any(
                (q) => q['quote'] == quote,
              );

              return IconButton(
                onPressed: () {
                  context
                      .read<FavoriteBloc>()
                      .add(
                        ToggleFavoriteEvent(
                          quoteMap,               
                        ),
                      );
                      
                  ScaffoldMessenger.of(context)
                      .clearSnackBars();

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        isFav
                            ? 'Removed from favorites 💔'
                            : 'Quote added to favorites ❤️',
                      ),
                      duration:
                          const Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                  isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFav
                      ? Colors.red
                      : secondaryTextColor,
>>>>>>> origin/qandeel
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,

            child: _QuoteActions(
              quote: quote,
              author: author,
              secondaryTextColor: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// QUOTE ACTIONS
// =====================================================

class _QuoteActions extends StatelessWidget {
  final String quote;
  final String author;
  final Color secondaryTextColor;

  const _QuoteActions({
    required this.quote,
    required this.author,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> quoteMap = {'quote': quote, 'author': author};

    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, favState) {
        final bool isFavorite = favState.favoriteQuotes.any(
          (item) => item['quote']?.toString() == quote,
        );

        return Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            IconButton(
              onPressed: () {
                context.read<FavoriteBloc>().add(ToggleFavoriteEvent(quoteMap));

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? 'Quote removed from favorites 💔'
                            : 'Quote added to favorites ❤️',
                      ),

                      duration: const Duration(seconds: 1),

                      behavior: SnackBarBehavior.floating,
                    ),
                  );
              },

              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,

                color: isFavorite ? Colors.red : secondaryTextColor,

                size: 25,
              ),
            ),

            IconButton(
              onPressed: () async {
                final text = '"$quote"\n— $author';

                await Clipboard.setData(ClipboardData(text: text));

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Quote copied successfully 📋'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
              },

              icon: Icon(
                Icons.copy_rounded,
                color: secondaryTextColor,
                size: 23,
              ),
            ),

            IconButton(
              onPressed: () {
                final shareText = '"$quote"\n— $author';

                Share.share(shareText);
              },

              icon: Icon(
                Icons.share_outlined,
                color: secondaryTextColor,
                size: 23,
              ),
            ),
          ],
        );
      },
    );
  }
}