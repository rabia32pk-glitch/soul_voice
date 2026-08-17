import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/core/theme/theme_cubit.dart';
import 'package:soul_voice/services/models/quote_model.dart';
import 'package:soul_voice/services/quote_api_service.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

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
    );
  }
}