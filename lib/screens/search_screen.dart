import 'package:flutter/material.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/services/models/quote_model.dart';
import '../services/quote_api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final QuoteApiService _quoteApiService = QuoteApiService();
  final TextEditingController _searchController = TextEditingController();

  Future<List<QuoteModel>>? _searchFuture;

  final List<String> categories = [
    'Faith',
    'Life',
    'Wisdom',
    'Success',
    'Love',
    'Peace',
  ];

  String? selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchQuotes() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter something to search.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _searchFuture = _quoteApiService.searchQuotes(query);
    });
  }

  void _searchByCategory(String category) {
    FocusScope.of(context).unfocus();

    setState(() {
      selectedCategory = category;
      _searchFuture = _quoteApiService.getQuotesByCategory(
        category.toLowerCase(),
      );
    });
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      selectedCategory = null;
      _searchFuture = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Search Quotes',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= SEARCH BAR =================
              Container(
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 15),

                    const Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          hintText: 'Search quotes...',
                          hintStyle: TextStyle(color: AppColors.textSecondary),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) {
                          _searchQuotes();
                        },
                      ),
                    ),

                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        onPressed: _clearSearch,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textSecondary,
                        ),
                      ),

                    Container(
                      margin: const EdgeInsets.only(right: 6),
                      child: IconButton(
                        onPressed: _searchQuotes,
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ================= CATEGORIES =================
              const Text(
                'Browse by Category',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categories.map((category) {
                  final isSelected = selectedCategory == category;

                  return GestureDetector(
                    onTap: () {
                      _searchByCategory(category);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // ================= RESULTS =================
              if (_searchFuture == null)
                _buildInitialMessage()
              else
                FutureBuilder<List<QuoteModel>>(
                  future: _searchFuture,
                  builder: (context, snapshot) {
                    // LOADING
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }

                    // ERROR
                    if (snapshot.hasError) {
                      return _buildError();
                    }

                    final quotes = snapshot.data ?? [];

                    // EMPTY
                    if (quotes.isEmpty) {
                      return _buildEmpty();
                    }

                    // SUCCESS
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedCategory != null
                              ? '$selectedCategory Quotes'
                              : 'Search Results',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 14),

                        ...quotes.map(
                          (quote) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _SearchQuoteCard(
                              quote: quote.content,
                              author: quote.author,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_rounded, color: AppColors.primary, size: 50),

          SizedBox(height: 15),

          Text(
            'Find Your Quote',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Search for quotes or select a category '
            'to discover inspiring words.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(Icons.cloud_off_rounded, color: AppColors.primary, size: 45),

          SizedBox(height: 12),

          Text(
            'Something went wrong',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 7),

          Text(
            'Unable to load quotes. Please try again.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(Icons.format_quote_rounded, color: AppColors.primary, size: 45),

          SizedBox(height: 12),

          Text(
            'No Quotes Found',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 7),

          Text(
            'Try another search or choose a different category.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// QUOTE CARD
// =====================================================

class _SearchQuoteCard extends StatelessWidget {
  final String quote;
  final String author;

  const _SearchQuoteCard({required this.quote, required this.author});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
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
                  quote,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '— $author',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border_rounded,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
