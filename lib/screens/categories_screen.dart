import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/screens/favorite_bloc.dart';
import 'package:soul_voice/screens/favorite_event.dart';
import 'package:soul_voice/screens/favorite_state.dart';
import 'package:soul_voice/services/models/quote_model.dart';
import '../services/quote_api_service.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDark ? AppColors.background : Colors.white;

    final primaryTextColor =
        isDark
            ? AppColors.textPrimary
            : Colors.black87;

    final secondaryTextColor =
        isDark
            ? AppColors.textSecondary
            : Colors.black54;

    final categories = [
      {
        'name': 'Faith',
        'tag': 'faith',
        'icon': Icons.auto_awesome_rounded,
        'description': 'Quotes about faith, belief, and hope',
        'gradient': [
          const Color(0xFF2E1C0C),
          const Color(0xFF8D5B14),
          const Color(0xFF1F1206),
        ],
        'accent': const Color(0xFFFFD54F),
      },
      {
        'name': 'Life',
        'tag': 'life',
        'icon': Icons.wb_sunny_outlined,
        'description': 'Quotes about life and the journey',
        'gradient': [
          const Color(0xFF1A2A3A),
          const Color(0xFF2E5B70),
          const Color(0xFF101B24),
        ],
        'accent': const Color(0xFF81D4FA),
      },
      {
        'name': 'Wisdom',
        'tag': 'wisdom',
        'icon': Icons.lightbulb_outline_rounded,
        'description': 'Words of wisdom and knowledge',
        'gradient': [
          const Color(0xFF1E1B4B),
          const Color(0xFF3730A3),
          const Color(0xFF0F172A),
        ],
        'accent': const Color(0xFFA5B4FC),
      },
      {
        'name': 'Success',
        'tag': 'success',
        'icon': Icons.trending_up_rounded,
        'description': 'Motivation to achieve your goals',
        'gradient': [
          const Color(0xFF064E3B),
          const Color(0xFF047857),
          const Color(0xFF022C22),
        ],
        'accent': const Color(0xFF6EE7B7),
      },
      {
        'name': 'Love',
        'tag': 'love',
        'icon': Icons.favorite_border_rounded,
        'description': 'Quotes about love, affection, and care',
        'gradient': [
          const Color(0xFF4C0519),
          const Color(0xFF9F1239),
          const Color(0xFF2B020D),
        ],
        'accent': const Color(0xFFFDA4AF),
      },
      {
        'name': 'Peace',
        'tag': 'peace',
        'icon': Icons.spa_outlined,
        'description': 'Calm, serene, and peaceful thoughts',
        'gradient': [
          const Color(0xFF083344),
          const Color(0xFF0E7490),
          const Color(0xFF041F2B),
        ],
        'accent': const Color(0xFF67E8F9),
      },
      {
        'name': 'Courage',
        'tag': 'courage',
        'icon': Icons.shield_outlined,
        'description': 'Bravery and boldness in adversity',
        'gradient': [
          const Color(0xFF450A0A),
          const Color(0xFF991B1B),
          const Color(0xFF260404),
        ],
        'accent': const Color(0xFFFCA5A5),
      },
      {
        'name': 'Hope',
        'tag': 'hope',
        'icon': Icons.wb_incandescent_outlined,
        'description': 'Light for difficult times',
        'gradient': [
          const Color(0xFF3B2404),
          const Color(0xFFB45309),
          const Color(0xFF1E1303),
        ],
        'accent': const Color(0xFFFDE047),
      },
      {
        'name': 'Patience',
        'tag': 'patience',
        'icon': Icons.hourglass_empty_rounded,
        'description': 'Strength in waiting and endurance',
        'gradient': [
          const Color(0xFF292524),
          const Color(0xFF57534E),
          const Color(0xFF141211),
        ],
        'accent': const Color(0xFFE7E5E4),
      },
      {
        'name': 'Gratitude',
        'tag': 'gratitude',
        'icon': Icons.volunteer_activism_outlined,
        'description': 'Thankfulness and appreciation',
        'gradient': [
          const Color(0xFF3B1A45),
          const Color(0xFF701A75),
          const Color(0xFF200926),
        ],
        'accent': const Color(0xFFF0ABFC),
      },
      {
        'name': 'Strength',
        'tag': 'strength',
        'icon': Icons.fitness_center_rounded,
        'description': 'Inner power and resilience',
        'gradient': [
          const Color(0xFF1E293B),
          const Color(0xFF334155),
          const Color(0xFF0F172A),
        ],
        'accent': const Color(0xFFCBD5E1),
      },
      {
        'name': 'Happiness',
        'tag': 'happiness',
        'icon': Icons.sentiment_very_satisfied_rounded,
        'description': 'Joy, smiles, and positive vibes',
        'gradient': [
          const Color(0xFF431407),
          const Color(0xFF9A3412),
          const Color(0xFF240A04),
        ],
        'accent': const Color(0xFFFDBA74),
      },
      {
        'name': 'Motivation',
        'tag': 'motivation',
        'icon': Icons.bolt_rounded,
        'description': 'Inspiration to keep pushing forward',
        'gradient': [
          const Color(0xFF3B0764),
          const Color(0xFF6B21A8),
          const Color(0xFF1E0338),
        ],
        'accent': const Color(0xFFD8B4FE),
      },
      {
        'name': 'Friendship',
        'tag': 'friendship',
        'icon': Icons.people_outline_rounded,
        'description': 'Bonds of true companionship',
        'gradient': [
          const Color(0xFF134E4A),
          const Color(0xFF0F766E),
          const Color(0xFF042F2E),
        ],
        'accent': const Color(0xFF5EEAD4),
      },
      {
        'name': 'Knowledge',
        'tag': 'knowledge',
        'icon': Icons.menu_book_rounded,
        'description': 'Learning and intellectual growth',
        'gradient': [
          const Color(0xFF172554),
          const Color(0xFF1E40AF),
          const Color(0xFF0B132B),
        ],
        'accent': const Color(0xFF93C5FD),
      },
      {
        'name': 'Kindness',
        'tag': 'kindness',
        'icon': Icons.handshake_outlined,
        'description': 'Compassion and gentle actions',
        'gradient': [
          const Color(0xFF2E1065),
          const Color(0xFF5B21B6),
          const Color(0xFF170638),
        ],
        'accent': const Color(0xFFC4B5FD),
      },
      {
        'name': 'Time',
        'tag': 'time',
        'icon': Icons.access_time_rounded,
        'description': 'Valuing moments and seasons',
        'gradient': [
          const Color(0xFF18181B),
          const Color(0xFF3F3F46),
          const Color(0xFF09090B),
        ],
        'accent': const Color(0xFFD4D4D8),
      },
      {
        'name': 'Forgiveness',
        'tag': 'forgiveness',
        'icon': Icons.self_improvement_rounded,
        'description': 'Letting go and healing the heart',
        'gradient': [
          const Color(0xFF064E3B),
          const Color(0xFF059669),
          const Color(0xFF022C22),
        ],
        'accent': const Color(0xFFA7F3D0),
      },
      {
        'name': 'Truth',
        'tag': 'truth',
        'icon': Icons.verified_outlined,
        'description': 'Honesty, integrity, and reality',
        'gradient': [
          const Color(0xFF0C4A6E),
          const Color(0xFF0369A1),
          const Color(0xFF082F49),
        ],
        'accent': const Color(0xFF7DD3FC),
      },
      {
        'name': 'Future',
        'tag': 'future',
        'icon': Icons.explore_outlined,
        'description': 'Looking ahead with hope',
        'gradient': [
          const Color(0xFF1E1B4B),
          const Color(0xFF3730A3),
          const Color(0xFF0D0B2E),
        ],
        'accent': const Color(0xFFA5B4FC),
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        screenWidth >= 900 ? 4 : (screenWidth >= 600 ? 3 : 2);
    final childAspectRatio = screenWidth < 360 ? 1.05 : 1.15;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Categories',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: primaryTextColor,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore Quotes',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Choose a category and discover inspiring quotes.',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: categories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        return _CategoryCard(
                          name: category['name'] as String,
                          icon: category['icon'] as IconData,
                          description: category['description'] as String,
                          gradientColors:
                              category['gradient'] as List<Color>,
                          accentColor: category['accent'] as Color,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryQuotesScreen(
                                  category: category['name'] as String,
                                  categoryTag: category['tag'] as String,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// CATEGORY CARD (100% OFFLINE GRADIENT & GLASSMORPHISM)
// =====================================================

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final String description;
  final List<Color> gradientColors;
  final Color accentColor;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.description,
    required this.gradientColors,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // 1. Ambient Radial Highlight (Top Right)
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. Large Translucent Background Watermark Icon (Bottom Right)
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Opacity(
                    opacity: 0.12,
                    child: Icon(
                      icon,
                      size: 90,
                      color: Colors.white,
                    ),
                  ),
                ),

                // 3. Card Content
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Glassmorphic Icon Badge
                      Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: accentColor,
                          size: 20,
                        ),
                      ),

                      // Text Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontSize: 11,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// CATEGORY QUOTES SCREEN
// INFINITE SCROLLING
// =====================================================

class CategoryQuotesScreen
    extends StatefulWidget {
  final String category;
  final String? categoryTag;

  const CategoryQuotesScreen({
    super.key,
    required this.category,
    this.categoryTag,
  });

  @override
  State<CategoryQuotesScreen> createState() =>
      _CategoryQuotesScreenState();
}

class _CategoryQuotesScreenState
    extends State<CategoryQuotesScreen> {

  final QuoteApiService _apiService =
      QuoteApiService();

  final ScrollController _scrollController =
      ScrollController();

  // All quotes currently shown
  final List<QuoteModel> _quotes = [];

  // Original quotes received for category
  List<QuoteModel> _categoryQuotes = [];

  bool _isInitialLoading = true;
  bool _isLoadingMore = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(
      _onScroll,
    );

    _loadInitialQuotes();
  }

  @override
  void dispose() {
    _scrollController.removeListener(
      _onScroll,
    );

    _scrollController.dispose();

    super.dispose();
  }

  // =====================================================
  // INITIAL LOAD
  // =====================================================

  Future<void> _loadInitialQuotes() async {
    setState(() {
      _isInitialLoading = true;
      _errorMessage = null;
    });

    try {
      final tagToFetch =
          widget.categoryTag ??
          widget.category
              .toLowerCase()
              .replaceAll(' ', '_');

      final result =
          await _apiService.getQuotesByCategory(
        tagToFetch,
      );

      if (!mounted) return;

      if (result.isEmpty) {
        setState(() {
          _isInitialLoading = false;
          _errorMessage =
              'No ${widget.category} quotes found.';
        });

        return;
      }

      _categoryQuotes =
          List<QuoteModel>.from(result);

      _categoryQuotes.shuffle();

      _quotes.clear();

      _quotes.addAll(
        _categoryQuotes,
      );

      setState(() {
        _isInitialLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isInitialLoading = false;
        _errorMessage =
            'Unable to load quotes.';
      });
    }
  }

  // =====================================================
  // SCROLL LISTENER
  // =====================================================

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position =
        _scrollController.position;

    // Load more before reaching bottom
    if (position.pixels >=
        position.maxScrollExtent - 500) {
      _loadMoreQuotes();
    }
  }

  // =====================================================
  // LOAD MORE
  // =====================================================

  Future<void> _loadMoreQuotes() async {
    if (_isLoadingMore) {
      return;
    }

    if (_categoryQuotes.isEmpty) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    // Create a new shuffled batch
    final List<QuoteModel> newBatch =
        List<QuoteModel>.from(
      _categoryQuotes,
    );

    newBatch.shuffle();

    setState(() {
      _quotes.addAll(newBatch);
      _isLoadingMore = false;
    });
  }

  // =====================================================
  // RETRY
  // =====================================================

  Future<void> _retry() async {
    await _loadInitialQuotes();
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final backgroundColor =
        isDark
            ? AppColors.background
            : Colors.white;

    final surfaceColor =
        isDark
            ? AppColors.surface
            : const Color(0xFFF7F7F7);

    final primaryTextColor =
        isDark
            ? AppColors.textPrimary
            : Colors.black87;

    final secondaryTextColor =
        isDark
            ? AppColors.textSecondary
            : Colors.black54;

    final borderColor =
        isDark
            ? AppColors.border
            : const Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          '${widget.category} Quotes',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: primaryTextColor,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: _buildBody(
              surfaceColor: surfaceColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
              borderColor: borderColor,
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // BODY
  // =====================================================

  Widget _buildBody({
    required Color surfaceColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color borderColor,
  }) {
    // ===================================================
    // INITIAL LOADING
    // ===================================================

    if (_isInitialLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    // ===================================================
    // ERROR
    // ===================================================

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: AppColors.primary,
                size: 55,
              ),
              const SizedBox(height: 15),
              Text(
                'Unable to load quotes',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _retry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Try Again',
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ===================================================
    // EMPTY
    // ===================================================

    if (_quotes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.format_quote_rounded,
                color: AppColors.primary,
                size: 55,
              ),
              const SizedBox(height: 15),
              Text(
                'No ${widget.category} quotes found',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try another category.',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ===================================================
    // INFINITE QUOTES LIST
    // ===================================================

    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, favState) {
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          // +1 = loading indicator
          itemCount: _quotes.length + 1,
          itemBuilder: (context, index) {
            // =========================================
            // LOADING MORE
            // =========================================

            if (index == _quotes.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: _isLoadingMore
                      ? const CircularProgressIndicator(
                          color: AppColors.primary,
                        )
                      : const SizedBox(height: 20),
                ),
              );
            }

            // =========================================
            // CURRENT QUOTE
            // =========================================

            final quote = _quotes[index];
            final quoteMap = {
              'quote': quote.content,
              'author': quote.author,
            };

            final isFav = favState.isFavoriteText(quote.content);

            // =========================================
            // QUOTE CARD
            // =========================================

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===================================
                  // QUOTE
                  // ===================================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.format_quote_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quote.content,
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 15,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '— ${quote.author}',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ===================================
                  // BUTTONS
                  // ===================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // ===============================
                      // FAVORITE
                      // ===============================
                      IconButton(
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          context.read<FavoriteBloc>().add(
                                ToggleFavoriteEvent(
                                  quoteMap,
                                ),
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
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFav ? Colors.red : AppColors.primary,
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 4),

                      // ===============================
                      // COPY
                      // ===============================
                      IconButton(
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                        onPressed: () async {
                          final text = '"${quote.content}"\n— ${quote.author}';
                          await Clipboard.setData(
                            ClipboardData(
                              text: text,
                            ),
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Quote copied successfully 📋',
                                ),
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          Icons.copy_rounded,
                          color: secondaryTextColor,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 4),

                      // ===============================
                      // SHARE
                      // ===============================
                      IconButton(
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          final shareText = '"${quote.content}"\n— ${quote.author}';
                          SharePlus.instance.share(
                            ShareParams(
                              text: shareText,
                              subject: 'Soul Voice Quote',
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.share_outlined,
                          color: secondaryTextColor,
                          size: 21,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}