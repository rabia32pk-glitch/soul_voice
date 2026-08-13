import 'package:flutter/material.dart';
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
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
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
            quote: 'Peace begins with a calm mind and a hopeful heart.',
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

class QuoteCard extends StatelessWidget {
  final String quote;
  final String author;

  const QuoteCard({super.key, required this.quote, required this.author});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
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

          const SizedBox(height: 15),

          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border_rounded,
                  color: AppColors.primary,
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
