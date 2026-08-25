import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import 'package:soul_voice/core/theme/constants/app_colors.dart';
import 'package:soul_voice/services/models/quote_model.dart';
import 'package:soul_voice/services/quote_api_service.dart';
import 'package:soul_voice/screens/favorite_bloc.dart';
import 'package:soul_voice/screens/favorite_event.dart';
import 'package:soul_voice/screens/favorite_state.dart';

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

  // ================= POPULAR INSPIRATIONAL SUGGESTIONS =================
  final List<String> allSuggestions = const [
    'Faith',
    'Wisdom',
    'Peace',
    'Patience',
    'Love',
    'Life',
    'Success',
    'Courage',
    'Hope',
    'Gratitude',
    'Strength',
    'Happiness',
    'Motivation',
    'Friendship',
    'Knowledge',
    'Kindness',
    'Time',
    'Forgiveness',
    'Truth',
    'Future',
    'Prayer',
    'Sabr',
    'Heart',
    'Smile',
    'Goals',
    'Dreams',
    'Mind',
    'Allah',
    'Dua',
    'Effort',
    'Joy',
    'Trust',
    'Honesty',
    'Hardwork',
    'Destiny',
    'Reflection',
  ];

  List<String> _filteredSuggestions = [];

  void _showSuggestions(String query) {
    final clean = query.trim().toLowerCase();
    setState(() {
      if (clean.isEmpty) {
        _filteredSuggestions = [];
      } else {
        _filteredSuggestions = allSuggestions
            .where((word) => word.toLowerCase().contains(clean))
            .toList();
      }
    });
  }

  // ================= SEARCH FUNCTION =================
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
      _filteredSuggestions = [];
    });

    try {
      final results = await _apiService.searchQuotes(trimmedQuery);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.background : const Color(0xFFFBF8F2);
    final surfaceColor = isDark ? AppColors.surface : Colors.white;
    final primaryTextColor = isDark ? AppColors.textPrimary : const Color(0xFF2C241D);
    final secondaryTextColor = isDark ? AppColors.textSecondary : const Color(0xFF6B5E52);
    final borderColor = isDark ? AppColors.border : const Color(0xFFE8DFD1);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Search Quotes',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // ================= SEARCH INPUT =================
                  TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(color: primaryTextColor),
                    onSubmitted: (value) => _performSearch(value),
                    onChanged: (value) {
                      _showSuggestions(value);
                      if (value.isEmpty) {
                        _performSearch('');
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: surfaceColor,
                      hintText: 'Search by keyword, topic or author...',
                      hintStyle: TextStyle(color: secondaryTextColor, fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: secondaryTextColor,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                color: secondaryTextColor,
                                size: 20,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _filteredSuggestions = [];
                                  _searchResults = [];
                                  _hasSearched = false;
                                  _isLoading = false;
                                });
                              },
                            )
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: borderColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),

                  // ================= SUGGESTIONS LIST =================
                  if (_filteredSuggestions.isNotEmpty)
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxHeight: 220),
                      margin: const EdgeInsets.only(top: 6),
                      child: Material(
                        color: surfaceColor,
                        elevation: 4,
                        shadowColor: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: borderColor),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _filteredSuggestions.length,
                          separatorBuilder: (_, _) => Divider(
                            height: 1,
                            color: borderColor.withValues(alpha: 0.5),
                          ),
                          itemBuilder: (context, index) {
                            final suggestion = _filteredSuggestions[index];
                            return ListTile(
                              dense: true,
                              leading: const Icon(
                                Icons.search_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                              title: Text(
                                suggestion,
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                _searchController.text = suggestion;
                                setState(() {
                                  _filteredSuggestions = [];
                                });
                                _performSearch(suggestion);
                              },
                            );
                          },
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // ================= RESULTS BODY =================
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : !_hasSearched
                        ? _buildInitialState(
                            primaryTextColor,
                            secondaryTextColor,
                            surfaceColor,
                            borderColor,
                          )
                        : _searchResults.isEmpty
                        ? _buildEmptyState(
                            primaryTextColor,
                            secondaryTextColor,
                            surfaceColor,
                            borderColor,
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _searchResults.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final quote = _searchResults[index];
                              return _QuoteCard(
                                quote: quote.content,
                                author: quote.author,
                                surfaceColor: surfaceColor,
                                borderColor: borderColor,
                                primaryTextColor: primaryTextColor,
                                secondaryTextColor: secondaryTextColor,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= INITIAL STATE WITH QUICK TAGS =================
  Widget _buildInitialState(
    Color primaryTextColor,
    Color secondaryTextColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    const popularTags = [
      'Faith',
      'Peace',
      'Wisdom',
      'Success',
      'Patience',
      'Love',
      'Hope',
      'Gratitude',
      'Strength',
      'Happiness',
      'Kindness',
      'Future',
    ];

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.manage_search_rounded,
                size: 54,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Search Any Topic or Keyword',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Type any word, category, or author name to find quotes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: secondaryTextColor, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Text(
              'Popular Topics',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: popularTags.map((tag) {
                return ActionChip(
                  label: Text(
                    tag,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: surfaceColor,
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    _searchController.text = tag;
                    _performSearch(tag);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ================= EMPTY STATE =================
  Widget _buildEmptyState(
    Color primaryTextColor,
    Color secondaryTextColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    const suggestedTags = ['Faith', 'Life', 'Wisdom', 'Peace', 'Hope', 'Patience'];

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 58,
              color: AppColors.primary,
            ),
            const SizedBox(height: 14),
            Text(
              'No quotes found',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'We couldn\'t find any quotes matching "${_searchController.text}".',
              textAlign: TextAlign.center,
              style: TextStyle(color: secondaryTextColor, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Text(
              'Try searching for:',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: suggestedTags.map((tag) {
                return ActionChip(
                  label: Text(
                    tag,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: surfaceColor,
                  side: BorderSide(color: borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    _searchController.text = tag;
                    _performSearch(tag);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= SEARCH QUOTE CARD =================
class _QuoteCard extends StatelessWidget {
  final String quote;
  final String author;
  final Color surfaceColor;
  final Color borderColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  const _QuoteCard({
    required this.quote,
    required this.author,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  String _cleanText(String text) {
    return text.replaceAll(RegExp(r'["“”‘’`\\]'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final String cleanQuoteText = _cleanText(quote);
    final quoteMap = {'quote': cleanQuoteText, 'author': author};

    return Container(
      width: double.infinity,
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
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cleanQuoteText,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '— $author',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ================= ACTION BUTTONS =================
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, favState) {
              final isFav = favState.isFavoriteText(cleanQuoteText);

              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ❤️ FAVORITE BUTTON
                  IconButton(
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      context.read<FavoriteBloc>().add(
                        ToggleFavoriteEvent(quoteMap),
                      );

                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFav
                                ? 'Removed from favorites 💔'
                                : 'Quote added to favorites ❤️',
                          ),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFav ? Colors.red : secondaryTextColor,
                      size: 23,
                    ),
                  ),
                  const SizedBox(width: 4),

                  // 📋 COPY BUTTON
                  IconButton(
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                    onPressed: () async {
                      final text = '$cleanQuoteText\n— $author';
                      await Clipboard.setData(ClipboardData(text: text));

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Quote copied successfully 📋'),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.copy_rounded,
                      color: secondaryTextColor,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 4),

                  // ↗️ SHARE BUTTON
                  IconButton(
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      final shareText = '$cleanQuoteText\n— $author';
                      SharePlus.instance.share(
                        ShareParams(
                          text: shareText,
                          subject: 'Soul Voice Quote',
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.share_outlined,
                      color: secondaryTextColor,
                      size: 21,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}