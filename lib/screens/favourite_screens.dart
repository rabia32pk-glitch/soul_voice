import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';

import 'package:soul_voice/screens/favorite_bloc.dart';
import 'package:soul_voice/screens/favorite_event.dart';
import 'package:soul_voice/screens/favorite_state.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // -----------------------------------------------------
  // Quotes jo is screen par display honge
  // -----------------------------------------------------

  final List<Map<String, dynamic>> _displayedQuotes = [];

  // -----------------------------------------------------
  // SnackBar key
  // -----------------------------------------------------

  final GlobalKey<ScaffoldMessengerState> _snackBarKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    final favorites =
        context.read<FavoriteBloc>().state.favoriteQuotes;

    _displayedQuotes.addAll(
      favorites.map(
        (quote) => Map<String, dynamic>.from(quote),
      ),
    );
  }

  // -----------------------------------------------------
  // Check whether quote is currently favorite
  // -----------------------------------------------------

  bool _isFavorite(
    Map<String, dynamic> quoteData,
    FavoriteState state,
  ) {
    return state.favoriteQuotes.any(
      (item) => item['quote'] == quoteData['quote'],
    );
  }

  // -----------------------------------------------------
  // Show SnackBar
  // -----------------------------------------------------

  void _showSnackBar(String message) {
    _snackBarKey.currentState?.hideCurrentSnackBar();

    _snackBarKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // -----------------------------------------------------
  // Toggle Favorite
  // -----------------------------------------------------

  void _toggleFavorite(
    Map<String, dynamic> quoteData,
    bool currentlyFavorite,
  ) {
    context.read<FavoriteBloc>().add(
      ToggleFavoriteEvent(quoteData),
    );

    if (currentlyFavorite) {
      _showSnackBar(
        'Quote removed from favorites 💔',
      );
    } else {
      _showSnackBar(
        'Quote added to favorites ❤️',
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

        final backgroundColor = isDark
            ? AppColors.background
            : Colors.white;

        final surfaceColor = isDark
            ? AppColors.surface
            : const Color(0xFFF7F7F7);

        final primaryTextColor = isDark
            ? AppColors.textPrimary
            : Colors.black87;

        final secondaryTextColor = isDark
            ? AppColors.textSecondary
            : Colors.black54;

        final borderColor = isDark
            ? AppColors.border
            : const Color(0xFFE0E0E0);

        return BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, favoriteState) {
            return ScaffoldMessenger(
              key: _snackBarKey,

              child: Scaffold(
                backgroundColor: backgroundColor,

                // =================================================
                // APP BAR
                // =================================================

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

                // =================================================
                // BODY
                // =================================================

                body: _displayedQuotes.isEmpty
                    ? Center(
                        child: Text(
                          'No favorites added yet',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          20,
                          20,
                          100,
                        ),

                        itemCount: _displayedQuotes.length,

                        itemBuilder: (context, index) {
                          final quoteData =
                              _displayedQuotes[index];

                          final isFavorite = _isFavorite(
                            quoteData,
                            favoriteState,
                          );

                          return FavoriteQuoteCard(
                            key: ValueKey(
                              quoteData['quote'],
                            ),

                            quoteData: quoteData,

                            quote:
                                quoteData['quote'] ?? '',

                            author:
                                quoteData['author'] ??
                                'Soul Voice',

                            isFavorite: isFavorite,

                            surfaceColor:
                                surfaceColor,

                            borderColor:
                                borderColor,

                            primaryTextColor:
                                primaryTextColor,

                            secondaryTextColor:
                                secondaryTextColor,

                            onFavoritePressed: () {
                              _toggleFavorite(
                                quoteData,
                                isFavorite,
                              );
                            },
                          );
                        },
                      ),
              ),
            );
          },
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

  final bool isFavorite;

  final Color surfaceColor;
  final Color borderColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  final VoidCallback onFavoritePressed;

  const FavoriteQuoteCard({
    super.key,

    required this.quoteData,
    required this.quote,
    required this.author,
    required this.isFavorite,

    required this.surfaceColor,
    required this.borderColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,

    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(
        bottom: 14,
      ),

      padding: const EdgeInsets.all(
        20,
      ),

      decoration: BoxDecoration(
        color: surfaceColor,

        borderRadius: BorderRadius.circular(
          20,
        ),

        border: Border.all(
          color: borderColor,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // =================================================
          // QUOTE
          // =================================================

          Text(
            quote,

            style: TextStyle(
              color: primaryTextColor,
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          // =================================================
          // AUTHOR
          // =================================================

          Text(
            '— $author',

            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          // =================================================
          // HEART - BOTTOM RIGHT
          // =================================================

          Align(
            alignment: Alignment.centerRight,

            child: IconButton(
              onPressed: onFavoritePressed,

              tooltip: isFavorite
                  ? 'Remove from favorites'
                  : 'Add to favorites',

              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,

                color: isFavorite
                    ? AppColors.primary
                    : secondaryTextColor,

                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}