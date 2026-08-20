import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/screens/favorite_bloc.dart';
import 'package:soul_voice/screens/favorite_event.dart';
import 'package:soul_voice/screens/favorite_state.dart';
import 'package:soul_voice/services/models/quote_model.dart';
import '../services/quote_api_service.dart';
import 'package:flutter/services.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ================= THEME COLORS =================

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? AppColors.background : Colors.white;

    final surfaceColor = isDark ? AppColors.surface : const Color(0xFFF7F7F7);

    final primaryTextColor = isDark ? AppColors.textPrimary : Colors.black87;

    final secondaryTextColor = isDark
        ? AppColors.textSecondary
        : Colors.black54;

    final borderColor = isDark ? AppColors.border : const Color(0xFFE0E0E0);

    // ================= 20 CATEGORIES =================

    final categories = [
      {
        'name': 'Faith',
        'icon': Icons.auto_awesome_rounded,
        'description': 'Quotes about faith, belief, and hope',
        'image':
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Life',
        'icon': Icons.wb_sunny_outlined,
        'description': 'Quotes about life and the journey',
        'image':
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Wisdom',
        'icon': Icons.lightbulb_outline_rounded,
        'description': 'Words of wisdom and knowledge',
        'image':
            'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Success',
        'icon': Icons.trending_up_rounded,
        'description': 'Motivation to achieve your goals',
        'image':
            'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Love',
        'icon': Icons.favorite_border_rounded,
        'description': 'Quotes about love, affection, and care',
        'image':
            'https://images.unsplash.com/photo-1518199266791-5375a83190b7?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Peace',
        'icon': Icons.spa_outlined,
        'description': 'Calm, serene, and peaceful thoughts',
        'image':
            'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Hope',
        'icon': Icons.wb_twilight_rounded,
        'description': 'Light for difficult times',
        'image':
            'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Gratitude',
        'icon': Icons.volunteer_activism_outlined,
        'description': 'Thankfulness and appreciation',
        'image':
            'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Motivation',
        'icon': Icons.bolt_rounded,
        'description': 'Inspiration to keep pushing forward',
        'image':
            'https://images.unsplash.com/photo-1499750310107-5fef28a66643?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Hard Work',
        'icon': Icons.fitness_center_rounded,
        'description': 'Diligence, grit, and dedication',
        'image':
            'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Self-Care',
        'icon': Icons.self_improvement_rounded,
        'description': 'Nurturing your body and soul',
        'image':
            'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Patience',
        'icon': Icons.hourglass_empty_rounded,
        'description': 'Strength in waiting and endurance',
        'image':
            'https://images.unsplash.com/photo-1501139083538-0139583c060f?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Friendship',
        'icon': Icons.people_outline_rounded,
        'description': 'Bonds of true companionship',
        'image':
            'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Family',
        'icon': Icons.family_restroom_rounded,
        'description': 'Love and unity at home',
        'image':
            'https://images.unsplash.com/photo-1511895426328-dc8714191300?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Heartbreak',
        'icon': Icons.heart_broken_outlined,
        'description': 'Healing from loss and pain',
        'image':
            'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Trust',
        'icon': Icons.verified_user_outlined,
        'description': 'Belief in people and timing',
        'image':
            'https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Time',
        'icon': Icons.access_time_rounded,
        'description': 'Valuing moments and seasons',
        'image':
            'https://images.unsplash.com/photo-1508962914676-134849a727f0?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Morning',
        'icon': Icons.wb_cloudy_outlined,
        'description': 'Fresh starts for a new day',
        'image':
            'https://images.unsplash.com/photo-1470240731273-7821a6eeb6bd?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Night',
        'icon': Icons.nights_stay_outlined,
        'description': 'Reflections under the stars',
        'image':
            'https://images.unsplash.com/photo-1509114397022-ed747cca3f65?q=80&w=600&auto=format&fit=crop',
      },
      {
        'name': 'Mindset',
        'icon': Icons.psychology_outlined,
        'description': 'Shaping perspective and thought',
        'image':
            'https://images.unsplash.com/photo-1507679799987-c73779587ccf?q=80&w=600&auto=format&fit=crop',
      },
    ];

    return Scaffold(
      backgroundColor: backgroundColor,

      // ================= APP BAR =================
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

        iconTheme: IconThemeData(color: primaryTextColor),
      ),

      // ================= BODY =================
      body: SafeArea(
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
                style: TextStyle(color: secondaryTextColor, fontSize: 14),
              ),

              const SizedBox(height: 22),

              Expanded(
                child: GridView.builder(
                  itemCount: categories.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.95,
                  ),

                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return _CategoryCard(
                      name: category['name'] as String,
                      icon: category['icon'] as IconData,
                      description: category['description'] as String,
                      imageUrl: category['image'] as String,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryQuotesScreen(
                              category: category['name'] as String,
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
    );
  }
}

// =====================================================
// CATEGORY CARD
// =====================================================

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final String description;
  final String imageUrl;
  final Color surfaceColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.description,
    required this.imageUrl,
    required this.surfaceColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),

        child: Stack(
          children: [
            // ================= BACKGROUND IMAGE =================
            Positioned.fill(
              child: Container(
                color: surfaceColor,

                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: surfaceColor);
                  },
                ),
              ),
            ),

            // ================= GRADIENT =================
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),

                  borderRadius: BorderRadius.circular(20),

                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,

                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ================= ICON =================
                    Container(
                      height: 40,
                      width: 40,

                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),

                      child: Icon(icon, color: AppColors.primary, size: 22),
                    ),

                    const Spacer(),

                    // ================= NAME =================
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,

                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // ================= DESCRIPTION =================
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// CATEGORY QUOTES SCREEN
// =====================================================

class CategoryQuotesScreen extends StatefulWidget {
  final String category;

  const CategoryQuotesScreen({super.key, required this.category});

  @override
  State<CategoryQuotesScreen> createState() => _CategoryQuotesScreenState();
}

class _CategoryQuotesScreenState extends State<CategoryQuotesScreen> {
  final QuoteApiService _apiService = QuoteApiService();

  late Future<List<QuoteModel>> _quotesFuture;

  @override
  void initState() {
    super.initState();
    _fetchQuotes();
  }

  void _fetchQuotes() {
    _quotesFuture = _apiService.getQuotesByCategory(
      widget.category.toLowerCase().replaceAll(' ', '_'),
    );
  }

  void _retry() {
    setState(() {
      _fetchQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ================= THEME COLORS =================

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? AppColors.background : Colors.white;

    final surfaceColor = isDark ? AppColors.surface : const Color(0xFFF7F7F7);

    final primaryTextColor = isDark ? AppColors.textPrimary : Colors.black87;

    final secondaryTextColor = isDark
        ? AppColors.textSecondary
        : Colors.black54;

    final borderColor = isDark ? AppColors.border : const Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: backgroundColor,

      // ================= APP BAR =================
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

        iconTheme: IconThemeData(color: primaryTextColor),
      ),

      // ================= QUOTES =================
      body: FutureBuilder<List<QuoteModel>>(
        future: _quotesFuture,

        builder: (context, snapshot) {
          // ================= LOADING =================

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // ================= ERROR =================

          if (snapshot.hasError) {
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
                      textAlign: TextAlign.center,

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

                      style: TextStyle(color: secondaryTextColor, fontSize: 13),
                    ),

                    const SizedBox(height: 18),

                    ElevatedButton(
                      onPressed: _retry,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),

                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ================= EMPTY =================

          final quotes = snapshot.data ?? [];

          if (quotes.isEmpty) {
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
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Try another category.',
                      style: TextStyle(color: secondaryTextColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
            );
          }

          // ================= QUOTES LIST =================

          return BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, favState) {
              return ListView.builder(
                padding: const EdgeInsets.all(20),

                itemCount: quotes.length,

                itemBuilder: (context, index) {
                  final quote = quotes[index];

                  final quoteMap = {
                    'quote': quote.content,
                    'author': quote.author,
                  };

                  final isFav = favState.favoriteQuotes.any(
                    (q) => q['quote'] == quote.content,
                  );

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: surfaceColor,

                      borderRadius: BorderRadius.circular(18),

                      border: Border.all(color: borderColor),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Icon(
                          Icons.format_quote_rounded,
                          color: AppColors.primary,
                          size: 30,
                        ),

                        const SizedBox(height: 10),

                        Text(
                          quote.content,

                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 15,
                            height: 1.45,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          '— ${quote.author}',

                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            // ================= FAVORITE =================
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

                                color: isFav ? Colors.red : AppColors.primary,
                              ),
                            ),

                            // ================= COPY =================
                            IconButton(
                              onPressed: () async {
                                final text =
                                    '"${quote.content}"\n— ${quote.author}';

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

                            // ================= SHARE =================
                            IconButton(
                              onPressed: () {
                                final shareText =
                                    '"${quote.content}"\n— ${quote.author}';

                                Share.share(shareText);
                              },

                              icon: Icon(
                                Icons.share_outlined,
                                color: secondaryTextColor,
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
        },
      ),
    );
  }
}
