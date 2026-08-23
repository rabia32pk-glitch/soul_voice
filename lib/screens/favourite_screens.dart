import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/core/theme/widget/custom_card.dart';
import 'package:soul_voice/screens/favorite_bloc.dart';
import 'package:soul_voice/screens/favorite_event.dart';
import 'package:soul_voice/screens/favorite_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

        // ==============================
        // COLORS
        // ==============================

        final backgroundColor =
            isDark ? AppColors.background : Colors.white;

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

          // ==============================
          // APP BAR
          // ==============================

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

            iconTheme: IconThemeData(
              color: primaryTextColor,
            ),
          ),

          // ==============================
          // FAVORITES
          // ==============================

          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: BlocBuilder<FavoriteBloc, FavoriteState>(
                  builder: (context, state) {
                    final favorites = state.favoriteQuotes;

                    // ==============================
                    // NO FAVORITES
                    // ==============================

                    if (favorites.isEmpty) {
                      return Center(
                        child: Text(
                          'No favorites added yet',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    // ==============================
                    // FAVORITES LIST
                    // ==============================

                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final item = favorites[index];

                        final quote = item['quote']?.toString() ?? '';

                        final author = item['author']?.toString() ?? 'Soul Voice';

                        // ==============================
                        // CUSTOM FAVORITE CARD
                        // ==============================

                        return CustomFavoriteCard(
                          quoteData: item,
                          quote: quote,
                          author: author,
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          primaryTextColor: primaryTextColor,
                          secondaryTextColor: secondaryTextColor,
                        );
                      },
                    );
                  },
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
// FAVORITE QUOTE CARD
// =====================================================

class FavoriteQuoteCard extends StatelessWidget {
  final Map<String, dynamic> quoteData;
  final String quote;
  final String author;
  final Color surfaceColor;
  final Color borderColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  const FavoriteQuoteCard({
    super.key,
    required this.quoteData,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: AppColors.primary,
                size: 28,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  context.read<FavoriteBloc>().add(ToggleFavoriteEvent(quoteData));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Removed from Favorites'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
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