import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/services/models/quote_model.dart';
import 'package:soul_voice/services/quote_api_service.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

class QuotesScreen extends StatelessWidget {
  const QuotesScreen({super.key});
      
  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final QuoteApiService _quoteApiService = QuoteApiService();

  QuoteModel? currentQuote;
  bool isLoading = false;

  void loadQuote() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuoteModel quote = await _quoteApiService.fetchRandomQuote();
      setState(() {
        currentQuote = quote;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadQuote();
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
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

        final backgroundColor = isDark ? AppColors.background : Colors.white;
        final primaryTextColor =
            isDark ? AppColors.textPrimary : Colors.black87;
        final secondaryTextColor =
            isDark ? AppColors.textSecondary : Colors.black54;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Quotes",
              style: TextStyle(
                color: primaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(color: primaryTextColor),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: AppColors.primary,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '"${currentQuote?.content ?? "No Quote"}"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "- ${currentQuote?.author ?? "Unknown"}",
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: loadQuote,
                          child: const Text("Next Quote"),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },

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