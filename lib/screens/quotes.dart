import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/screens/favorite_bloc.dart';
import 'package:soul_voice/screens/favorite_event.dart';
import 'package:soul_voice/screens/favorite_state.dart';
import 'package:soul_voice/services/models/quote_model.dart';
import 'package:soul_voice/services/quote_api_service.dart';

class CategoryQuotesScreen extends StatefulWidget {
  final String category;

  const CategoryQuotesScreen({super.key, required this.category});

  @override
  State<CategoryQuotesScreen> createState() => _CategoryQuotesScreenState();
}

class _CategoryQuotesScreenState extends State<CategoryQuotesScreen> {
  final QuoteApiService _quoteApiService = QuoteApiService();
  late Future<List<QuoteModel>> _quotesFuture;

  @override
  void initState() {
    super.initState();
    _loadCategoryQuotes();
  }

  void _loadCategoryQuotes() {
    _quotesFuture = _quoteApiService.getQuotesByCategory(widget.category);
  }

  String _formatTitle(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

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

        final categoryTitle = _formatTitle(widget.category);

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: primaryTextColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '$categoryTitle Quotes',
              style: TextStyle(
                color: primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: FutureBuilder<List<QuoteModel>>(
            future: _quotesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No quotes found for "$categoryTitle"',
                    style: TextStyle(color: secondaryTextColor, fontSize: 16),
                  ),
                );
              }

              final quotes = snapshot.data!;

              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: quotes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final quote = quotes[index];
                  return Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor),
                    ),
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
                                    quote.content,
                                    style: TextStyle(
                                      color: primaryTextColor,
                                      fontSize: 15,
                                      height: 1.4,
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: _CategoryQuoteActions(
                            quote: quote.content,
                            author: quote.author,
                            secondaryTextColor: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
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

class _CategoryQuoteActions extends StatelessWidget {
  final String quote;
  final String author;
  final Color secondaryTextColor;

  const _CategoryQuoteActions({
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
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: '"$quote"\n— $author'),
                );
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Quote copied 📋'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
              },
              icon: Icon(
                Icons.copy_rounded,
                color: secondaryTextColor,
                size: 22,
              ),
            ),
            IconButton(
              onPressed: () => Share.share('"$quote"\n— $author'),
              icon: Icon(
                Icons.share_outlined,
                color: secondaryTextColor,
                size: 22,
              ),
            ),
          ],
        );
      },
    );
  }
}
