import 'package:flutter/material.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Favorites',
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

          FavoriteQuoteCard(
            quote:
                'Believe in yourself and keep moving forward.',
            author: 'Soul Voice',
          ),

          FavoriteQuoteCard(
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
// FAVORITE QUOTE CARD
// =====================================================

class FavoriteQuoteCard extends StatelessWidget {
  final String quote;
  final String author;

  const FavoriteQuoteCard({
    super.key,
    required this.quote,
    required this.author,
  });

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
            Icons.favorite_rounded,
            color: AppColors.primary,
            size: 28,
          ),

          const SizedBox(height: 12),

          Text(
            quote,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '— $author',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}