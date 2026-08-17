import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

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

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Favorites',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(color: primaryTextColor),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              FavoriteQuoteCard(
                quote: 'Believe in yourself and keep moving forward.',
                author: 'Soul Voice',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
              ),
              FavoriteQuoteCard(
                quote: 'Peace begins with a calm mind and a hopeful heart.',
                author: 'Soul Voice',
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryTextColor: primaryTextColor,
                secondaryTextColor: secondaryTextColor,
              ),
            ],
          ),
        );
      },
    );
  }
}

// =====================================================
// FAVORITE QUOTE CARD
// =====================================================

class FavoriteQuoteCard extends StatelessWidget {
  final String quote;
  final String author;
  final Color surfaceColor;
  final Color borderColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  const FavoriteQuoteCard({
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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
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
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '— $author',
            style: TextStyle(color: secondaryTextColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
