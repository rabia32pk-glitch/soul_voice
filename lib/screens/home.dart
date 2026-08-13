import 'package:flutter/material.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/screens/categories_screen.dart';
import 'package:soul_voice/screens/favourite_screens.dart';
import 'package:soul_voice/screens/notifications_screen.dart';
import 'package:soul_voice/screens/profie.dart';
import 'package:soul_voice/screens/quotes.dart';
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
      {
        'name': 'Faith',
        'icon': Icons.auto_awesome_rounded,
        'tag': 'faith',
      },
      {
        'name': 'Life',
        'icon': Icons.wb_sunny_outlined,
        'tag': 'life',
      },
      {
        'name': 'Wisdom',
        'icon': Icons.lightbulb_outline_rounded,
        'tag': 'wisdom',
      },
      {
        'name': 'Success',
        'icon': Icons.trending_up_rounded,
        'tag': 'success',
      },
      {
        'name': 'Love',
        'icon': Icons.favorite_border_rounded,
        'tag': 'love',
      },
      {
        'name': 'Peace',
        'icon': Icons.spa_outlined,
        'tag': 'peace',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      // =================================================
      // BODY
      // =================================================

      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _refreshQuotes,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // =================================================
                // TOP HEADER
                // =================================================

                Row(
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Assalam-o-Alaikum 👋',
                            style: TextStyle(
                              color:
                                  AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            'Welcome to Soul Voice',
                            style: TextStyle(
                              color:
                                  AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // =================================================
                    // NOTIFICATION BUTTON
                    // =================================================

                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color:
                              AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // =================================================
                // SEARCH
                // =================================================

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SearchScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 52,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color:
                              AppColors.textSecondary,
                        ),

                        SizedBox(width: 12),

                        Text(
                          'Search quotes...',
                          style: TextStyle(
                            color:
                                AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // =================================================
                // CATEGORIES TITLE
                // =================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      'Categories',
                      style: TextStyle(
                        color:
                            AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CategoriesScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color:
                              AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // =================================================
                // CATEGORY CARDS
                // =================================================

                SizedBox(
                  height: 105,
                  child: ListView.separated(
                    scrollDirection:
                        Axis.horizontal,
                    itemCount:
                        categories.length,
                    separatorBuilder:
                        (context, index) =>
                            const SizedBox(
                      width: 12,
                    ),
                    itemBuilder:
                        (context, index) {
                      final category =
                          categories[index];

                      return _CategoryCard(
                        name:
                            category['name']
                                as String,
                        icon:
                            category['icon']
                                as IconData,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
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

                // =================================================
                // DAILY QUOTE
                // =================================================

                const Text(
                  'Daily Quote',
                  style: TextStyle(
                    color:
                        AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(22),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Row(
                        children: [
                          Icon(
                            Icons
                                .auto_awesome_rounded,
                            color:
                                AppColors.primary,
                            size: 20,
                          ),

                          SizedBox(width: 8),

                          Text(
                            "Today's Inspiration",
                            style: TextStyle(
                              color:
                                  AppColors.primary,
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        '"Your journey may be difficult, '
                        'but every step makes you stronger."',
                        style: TextStyle(
                          color:
                              AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w600,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'Daily Inspiration',
                        style: TextStyle(
                          color:
                              AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end,
                        children: [

                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.share_outlined,
                              color:
                                  AppColors
                                      .textSecondary,
                            ),
                          ),

                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons
                                  .favorite_border_rounded,
                              color:
                                  AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // =================================================
                // FEATURED QUOTES
                // =================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      'Featured Quotes',
                      style: TextStyle(
                        color:
                            AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
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
                        color:
                            AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // =================================================
                // API QUOTES
                // =================================================

                FutureBuilder<List<QuoteModel>>(
                  future: _quotesFuture,
                  builder:
                      (context, snapshot) {

                    // -----------------------------
                    // LOADING
                    // -----------------------------

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding:
                              EdgeInsets.all(35),
                          child:
                              CircularProgressIndicator(
                            color:
                                AppColors.primary,
                          ),
                        ),
                      );
                    }

                    // -----------------------------
                    // ERROR
                    // -----------------------------

                    if (snapshot.hasError) {
                      return Container(
                        width:
                            double.infinity,
                        padding:
                            const EdgeInsets.all(22),
                        decoration:
                            BoxDecoration(
                          color:
                              AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                          border:
                              Border.all(
                            color:
                                AppColors.border,
                          ),
                        ),
                        child: Column(
                          children: [

                            const Icon(
                              Icons
                                  .cloud_off_rounded,
                              color:
                                  AppColors.primary,
                              size: 40,
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            const Text(
                              'Unable to load quotes',
                              style:
                                  TextStyle(
                                color:
                                    AppColors
                                        .textPrimary,
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 6,
                            ),

                            const Text(
                              'Please check your internet '
                              'connection and try again.',
                              textAlign:
                                  TextAlign.center,
                              style:
                                  TextStyle(
                                color:
                                    AppColors
                                        .textSecondary,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _loadQuotes();
                                });
                              },
                              child:
                                  const Text(
                                'Try Again',
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // -----------------------------
                    // EMPTY
                    // -----------------------------

                    final quotes =
                        snapshot.data ?? [];

                    if (quotes.isEmpty) {
                      return Container(
                        width:
                            double.infinity,
                        padding:
                            const EdgeInsets.all(
                          25,
                        ),
                        child: const Text(
                          'No quotes found.',
                          textAlign:
                              TextAlign.center,
                          style: TextStyle(
                            color:
                                AppColors
                                    .textSecondary,
                          ),
                        ),
                      );
                    }

                    // -----------------------------
                    // SUCCESS
                    // -----------------------------

                    return Column(
                      children: quotes
                          .take(5)
                          .map(
                            (quote) =>
                                Padding(
                              padding:
                                  const EdgeInsets
                                      .only(
                                bottom: 12,
                              ),
                              child:
                                  _QuoteCard(
                                quote:
                                    quote.content,
                                author:
                                    quote.author,
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

      // =================================================
      // BOTTOM NAVIGATION
      // =================================================

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: 0,

        backgroundColor:
            AppColors.surface,

        selectedItemColor:
            AppColors.primary,

        unselectedItemColor:
            AppColors.textSecondary,

        type:
            BottomNavigationBarType.fixed,

        elevation: 0,

        onTap: (index) {

          // HOME
          if (index == 0) {
            return;
          }

          // QUOTES
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const QuotesScreen(),
              ),
            );
          }

          // FAVORITES
          else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const FavoritesScreen(),
              ),
            );
          }

          // PROFILE
          else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ProfileScreen(),
              ),
            );
          }
        },

        items: const [

          BottomNavigationBarItem(
            icon:
                Icon(Icons.home_rounded),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.format_quote_rounded),
            label: 'Quotes',
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.favorite_border_rounded),
            label: 'Favorites',
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


// =====================================================
// CATEGORY CARD
// =====================================================

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 105,
        padding:
            const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.border,
          ),
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              color: AppColors.primary,
              size: 28,
            ),

            const SizedBox(height: 10),

            Text(
              name,
              textAlign:
                  TextAlign.center,
              style: const TextStyle(
                color:
                    AppColors.textPrimary,
                fontSize: 13,
                fontWeight:
                    FontWeight.w600,
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

  const _QuoteCard({
    required this.quote,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),

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
                  style: const TextStyle(
                    color:
                        AppColors.textPrimary,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '— $author',
                  style: const TextStyle(
                    color:
                        AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border_rounded,
              color:
                  AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}