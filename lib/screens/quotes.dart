import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';

class QuotesScreen extends StatelessWidget {
  const QuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Quotes',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          QuoteCard(
            quote:
                'Every day is a new beginning. Take a deep breath and start again.',
            author: 'Soul Voice',
          ),

          QuoteCard(
            quote: 'Believe in yourself and keep moving forward.',
            author: 'Soul Voice',
          ),

          QuoteCard(
            quote:
                'Peace begins with a calm mind and a hopeful heart.',
            author: 'Soul Voice',
          ),
        ],
      ),
    );
  }
}

// =====================================================
// QUOTE CARD
// =====================================================

class QuoteCard extends StatefulWidget {
  final String quote;
  final String author;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.author,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  // =====================================================
  // LOAD SAVED FAVORITE
  // =====================================================

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();

    final savedFavorite =
        prefs.getBool('favorite_${widget.quote}') ?? false;

    if (!mounted) return;

    setState(() {
      isFavorite = savedFavorite;
    });
  }

  // =====================================================
  // FAVORITE / UNFAVORITE
  // =====================================================

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isFavorite = !isFavorite;
    });

    await prefs.setBool(
      'favorite_${widget.quote}',
      isFavorite,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'Your quote has been added to favorites ❤️'
              : 'Your quote has been removed from favorites',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote_rounded,
            color: AppColors.primary,
            size: 32,
          ),

          const SizedBox(height: 10),

          Text(
            widget.quote,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '— ${widget.author}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFavorite
                      ? Colors.yellow
                      : AppColors.primary,
                  size: 28,
                ),
              ),

              const Spacer(),

              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.share_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}