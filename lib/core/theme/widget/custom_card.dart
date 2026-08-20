import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/screens/favorite_bloc.dart';
import 'package:soul_voice/screens/favorite_event.dart';

class CustomFavoriteCard extends StatelessWidget {
  final Map<String, dynamic> quoteData;
  final String quote;
  final String author;

  final Color surfaceColor;
  final Color borderColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  const CustomFavoriteCard({
    super.key,
    required this.quoteData,
    required this.quote,
    required this.author,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  // ==============================
  // COPY QUOTE
  // ==============================

  void _copyQuote(BuildContext context) {
    final text = '"$quote"\n\n— $author';

    Clipboard.setData(
      ClipboardData(text: text),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Quote copied successfully 📋'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ==============================
  // SHARE QUOTE
  // ==============================

  Future<void> _shareQuote() async {
    final text = '"$quote"\n\n— $author';

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: 'Soul Voice Quote',
      ),
    );
  }

  // ==============================
  // REMOVE FAVORITE
  // ==============================

  void _removeFavorite(BuildContext context) {
    context.read<FavoriteBloc>().add(
      ToggleFavoriteEvent(
        quoteData,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Quote removed from favorites 💔',
          ),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ==========================================
          // QUOTE + AUTHOR
          // ==========================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // QUOTATION ICON
              const Icon(
                Icons.format_quote_rounded,
                color: AppColors.primary,
                size: 28,
              ),

              const SizedBox(width: 10),

              // QUOTE + AUTHOR
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // QUOTE
                    Text(
                      quote,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // AUTHOR
                    Text(
                      '— $author',
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

          const SizedBox(height: 12),

          // ==========================================
          // COPY + SHARE + FAVORITE
          // ==========================================

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              // COPY
              IconButton(
                tooltip: 'Copy',
                onPressed: () {
                  _copyQuote(context);
                },
                icon: Icon(
                  Icons.copy_rounded,
                  color: secondaryTextColor,
                  size: 23,
                ),
              ),

              // SHARE
              IconButton(
                tooltip: 'Share',
                onPressed: () {
                  _shareQuote();
                },
                icon: Icon(
                  Icons.share_rounded,
                  color: secondaryTextColor,
                  size: 23,
                ),
              ),

              // FAVORITE
              IconButton(
                tooltip: 'Remove from favorites',
                onPressed: () {
                  _removeFavorite(context);
                },
                icon: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.red,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}