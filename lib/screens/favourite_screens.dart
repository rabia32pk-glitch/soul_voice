import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/core/theme/widget/custom_card.dart';
import 'package:soul_voice/screens/favorite_bloc.dart';
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

          body: BlocBuilder<FavoriteBloc, FavoriteState>(
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

                  final quote =
                      item['quote']?.toString() ?? '';

                  final author =
                      item['author']?.toString() ??
                          'Soul Voice';

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
        );
      },
    );
  }
}