import 'package:flutter/material.dart';
import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/services/models/quote_model.dart';
import 'package:soul_voice/services/quote_api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final QuoteApiService _apiService = QuoteApiService();
  final TextEditingController _searchController = TextEditingController();

  List<QuoteModel> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  void _performSearch(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final results = await _apiService.getQuotesByCategory(trimmedQuery);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Search Quotes',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // ================= PERFECT SEARCH INPUT =================
              TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: AppColors.textPrimary),
                onSubmitted: (value) => _performSearch(value),
                onChanged: (value) {
                  setState(() {}); // Clear icon update karne ke liye
                  if (value.isEmpty) {
                    _performSearch('');
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search by category or keyword...',
                  hintStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),

                  // Search Icon inside TextField
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                  ),

                  // Clear Icon inside TextField
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch('');
                          },
                        )
                      : null,

                  // Normal state border
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),

                  // Active / Focused state border (Yellow Line Pure Box Par Aaye Gi)
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= RESULTS BODY =================
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : !_hasSearched
                    ? _buildInitialState()
                    : _searchResults.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _searchResults.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final quote = _searchResults[index];
                          return _QuoteCard(
                            quote: quote.content,
                            author: quote.author,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Search start na hone par dikhne wala widget
  Widget _buildInitialState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.manage_search_rounded,
          size: 70,
          color: AppColors.textSecondary,
        ),
        SizedBox(height: 16),
        Text(
          'Find Your Motivation',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Type keywords like "faith", "life", or "wisdom" to search quotes.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  // Results na milne par dikhne wala widget
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.search_off_rounded,
          size: 60,
          color: AppColors.primary,
        ),
        const SizedBox(height: 14),
        const Text(
          'No quotes found',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'We couldn\'t find anything for "${_searchController.text}".',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}

// =====================================================
// QUOTE CARD (Same as HomeScreen Style)
// =====================================================

class _QuoteCard extends StatelessWidget {
  final String quote;
  final String author;

  const _QuoteCard({required this.quote, required this.author});

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
                  '"$quote"',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '- $author',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
