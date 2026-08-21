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

  // ================= SUGGESTIONS LIST =================
  final List<String> allSuggestions = [
    // A
    'Apple', 'Amazing', 'Adventure', 'Achievement', 'Attitude', 'Angel', 'Art', 'Alone',
    // B
    'Beauty', 'Believe', 'Bravery', 'Business', 'Balance', 'Blessing', 'Brother', 'Better',
    // C
    'Camera', 'Car', 'Coffee', 'Computer', 'Confidence', 'Courage', 'Change', 'Career',
    // D
    'Dream', 'Dreams', 'Daily', 'Danger', 'Dance', 'Decision', 'Desire', 'Destiny',
    // E
    'Education', 'Energy', 'Emotion', 'Enjoy', 'Effort', 'Experience', 'Equality', 'Excitement',
    // F
    'Faith', 'Family', 'Friendship', 'Freedom', 'Future', 'Focus', 'Fear', 'Forgiveness',
    // G
    'Goal', 'Goals', 'Good', 'Growth', 'Gratitude', 'Greatness', 'Gift', 'Guidance',
    // H
    'Hope', 'Happiness', 'Health', 'Heart', 'Honesty', 'Home', 'Help', 'Hardwork',
    // I
    'Inspiration', 'Important', 'Ideas', 'Intelligence', 'Improvement', 'Independence', 'Innovation', 'Integrity',
    // J
    'Joy', 'Journey', 'Justice', 'Job', 'Joke', 'Judgement', 'Jump', 'Jubilation',
    // K
    'Knowledge', 'Kindness', 'King', 'Keep', 'Key', 'Kids', 'Knowledgeable', 'Karma',
    // L
    'Love', 'Life', 'Luck', 'Leadership', 'Learning', 'Laugh', 'Light', 'Loyalty',
    // M
    'Mobile', 'Makeup', 'Medicine', 'Mango', 'Manager', 'Motivation', 'Money', 'Mind',
    // N
    'Nature', 'Never', 'New', 'Night', 'Name', 'Nation', 'Nice', 'Nothing',
    // O
    'Opportunity', 'Optimism', 'Open', 'Original', 'Objective', 'Ocean', 'Overcome', 'Outstanding',
    // P
    'Peace', 'Power', 'Passion', 'Patience', 'Positive', 'Purpose', 'Progress', 'Promise',
    // Q
    'Quality', 'Quiet', 'Quick', 'Question', 'Queen', 'Quest', 'Quote', 'Quotable',
    // R
    'Respect', 'Relationship', 'Success', 'Rise', 'Reality', 'Reason', 'Resilience', 'Reward',
    // S
    'Success', 'Smile', 'Strength', 'Study', 'Support', 'Self', 'Soul',
    // T
    'Trust', 'Time', 'Truth', 'Talent', 'Team', 'Together', 'Thought', 'Tomorrow',
    // U
    'Unity', 'Understanding', 'Unique', 'Useful', 'Ultimate', 'Universe', 'Upgrade', 'Urgent',
    // V
    'Victory', 'Value', 'Vision', 'Voice', 'Vitality', 'Virtue', 'Volunteer',
    // W
    'Wisdom', 'Work', 'World', 'Wonderful', 'Wealth', 'Welcome', 'Winning', 'Wish',
    // X
    'Xenon', 'Xylophone', 'Xenial', 'Xeric', 'Xylem', 'Xenophobia', 'Xerophyte', 'Xylograph',
    // Y
    'Youth', 'Young', 'Yes', 'Yesterday', 'Year', 'Yourself', 'Yoga', 'Yard',
    // Z
    'Zeal', 'Zero', 'Zone', 'Zest', 'Zen', 'Zoom', 'Zodiac', 'Zigzag',
  ];

  List<String> _suggestions = [];

  void _showSuggestions(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _suggestions = [];
      } else {
        _suggestions = allSuggestions
            .where((word) => word.toLowerCase().startsWith(query.toLowerCase()))
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
      _suggestions = [];
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.background : Colors.white;
    final surfaceColor = isDark ? AppColors.surface : const Color(0xFFF7F7F7);
    final primaryTextColor = isDark ? AppColors.textPrimary : Colors.black87;
    final secondaryTextColor = isDark
        ? AppColors.textSecondary
        : Colors.black54;
    final borderColor = isDark ? AppColors.border : const Color(0xFFE0E0E0);

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
                  hintText: 'Search by category or keyword...',
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
                              _suggestions = [];
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
                    borderSide: BorderSide(color: borderColor, width: 1.5),
                  ),
                ),
              ),

              // ================= SUGGESTIONS LIST =================
              if (_suggestions.isNotEmpty)
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxHeight: 220),
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.search_rounded,
                          color: secondaryTextColor,
                        ),
                        title: Text(
                          suggestion,
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                        onTap: () {
                          _searchController.text = suggestion;
                          setState(() {
                            _suggestions = [];
                          });
                          _performSearch(suggestion);
                        },
                      );
                    },
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
                    ? _buildInitialState(primaryTextColor, secondaryTextColor)
                    : _searchResults.isEmpty
                    ? _buildEmptyState(primaryTextColor, secondaryTextColor)
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _searchResults.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
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
    );
  }

  // ================= INITIAL STATE =================
  Widget _buildInitialState(Color primaryTextColor, Color secondaryTextColor) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.manage_search_rounded,
              size: 70,
              color: secondaryTextColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Find Your Motivation',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Type keywords like "faith", "life", or "wisdom" to search quotes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: secondaryTextColor, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // ================= EMPTY STATE =================
  Widget _buildEmptyState(Color primaryTextColor, Color secondaryTextColor) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 60,
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
              'We couldn\'t find anything for "${_searchController.text}".',
              textAlign: TextAlign.center,
              style: TextStyle(color: secondaryTextColor, fontSize: 13),
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

  // Function to remove all quotation marks
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
                size: 30,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PRINTING CLEANED TEXT WITHOUT HARDCODED QUOTES
                    Text(
                      cleanQuoteText,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '- $author',
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
          const SizedBox(height: 12),

          // ================= ACTION BUTTONS =================
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, favState) {
              final isFav = favState.favoriteQuotes.any(
                (q) => _cleanText(q['quote'] ?? '') == cleanQuoteText,
              );

              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ❤️ FAVORITE BUTTON
                  IconButton(
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
                        ),
                      );
                    },
                    icon: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFav ? Colors.red : secondaryTextColor,
                    ),
                  ),

                  // 📋 COPY BUTTON
                  IconButton(
                    onPressed: () async {
                      final text = '$cleanQuoteText\n— $author';
                      await Clipboard.setData(ClipboardData(text: text));

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Quote copied successfully 📋'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.copy_rounded, color: secondaryTextColor),
                  ),

                  // ↗️ SHARE BUTTON
                  IconButton(
                    onPressed: () {
                      final shareText = '$cleanQuoteText\n— $author';
                      Share.share(shareText);
                    },
                    icon: Icon(Icons.share_outlined, color: secondaryTextColor),
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