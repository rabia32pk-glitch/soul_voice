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

  // ================= SUGGESTIONS =================

  final List<String> allSuggestions = [
  
  // A
  'Apple',
  'Amazing',
  'Adventure',
  'Achievement',
  'Attitude',
  'Angel',
  'Art',
  'Alone',

  // B
  'Beauty',
  'Believe',
  'Bravery',
  'Business',
  'Balance',
  'Blessing',
  'Brother',
  'Better',

  // C
  'Camera',
  'Car',
  'Coffee',
  'Computer',
  'Confidence',
  'Courage',
  'Change',
  'Career',

  // D
  'Dream',
  'Dreams',
  'Daily',
  'Danger',
  'Dance',
  'Decision',
  'Desire',
  'Destiny',

  // E
  'Education',
  'Energy',
  'Emotion',
  'Enjoy',
  'Effort',
  'Experience',
  'Equality',
  'Excitement',

  // F
  'Faith',
  'Family',
  'Friendship',
  'Freedom',
  'Future',
  'Focus',
  'Fear',
  'Forgiveness',

  // G
  'Goal',
  'Goals',
  'Good',
  'Growth',
  'Gratitude',
  'Greatness',
  'Gift',
  'Guidance',

  // H
  'Hope',
  'Happiness',
  'Health',
  'Heart',
  'Honesty',
  'Home',
  'Help',
  'Hardwork',

  // I
  'Inspiration',
  'Important',
  'Ideas',
  'Intelligence',
  'Improvement',
  'Independence',
  'Innovation',
  'Integrity',

  // J
  'Joy',
  'Journey',
  'Justice',
  'Job',
  'Joke',
  'Judgement',
  'Jump',
  'Jubilation',

  // K
  'Knowledge',
  'Kindness',
  'King',
  'Keep',
  'Key',
  'Kids',
  'Knowledgeable',
  'Karma',

  // L
  'Love',
  'Life',
  'Luck',
  'Leadership',
  'Learning',
  'Laugh',
  'Light',
  'Loyalty',

  // M
  'Mobile',
  'Makeup',
  'Medicine',
  'Mango',
  'Manager',
  'Motivation',
  'Money',
  'Mind',

  // N
  'Nature',
  'Never',
  'New',
  'Night',
  'Name',
  'Nation',
  'Nice',
  'Nothing',

  // O
  'Opportunity',
  'Optimism',
  'Open',
  'Original',
  'Objective',
  'Ocean',
  'Overcome',
  'Outstanding',

  // P
  'Peace',
  'Power',
  'Passion',
  'Patience',
  'Positive',
  'Purpose',
  'Progress',
  'Promise',

  // Q
  'Quality',
  'Quiet',
  'Quick',
  'Question',
  'Queen',
  'Quest',
  'Quote',
  'Quotable',

  // R
  'Respect',
  'Relationship',
  'Success',
  'Rise',
  'Reality',
  'Reason',
  'Resilience',
  'Reward',

  // S
  'Success',
  'Smile',
  'Strength',
  'Success',
  'Study',
  'Support',
  'Self',
  'Soul',

  // T
  'Trust',
  'Time',
  'Truth',
  'Talent',
  'Team',
  'Together',
  'Thought',
  'Tomorrow',

  // U
  'Unity',
  'Understanding',
  'Unique',
  'Useful',
  'Ultimate',
  'Universe',
  'Upgrade',
  'Urgent',

  // V
  'Victory',
  'Value',
  'Vision',
  'Voice',
  'Victory',
  'Vitality',
  'Virtue',
  'Volunteer',

  // W
  'Wisdom',
  'Work',
  'World',
  'Wonderful',
  'Wealth',
  'Welcome',
  'Winning',
  'Wish',

  // X
  'Xenon',
  'Xylophone',
  'Xenial',
  'Xeric',
  'Xylem',
  'Xenophobia',
  'Xerophyte',
  'Xylograph',

  // Y
  'Youth',
  'Young',
  'Yes',
  'Yesterday',
  'Year',
  'Yourself',
  'Yoga',
  'Yard',

  // Z
  'Zeal',
  'Zero',
  'Zone',
  'Zest',
  'Zen',
  'Zoom',
  'Zodiac',
  'Zigzag',
];
  

  List<String> _suggestions = [];

  void _showSuggestions(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _suggestions = [];
      } else {
        _suggestions = allSuggestions
            .where(
              (word) => word.toLowerCase().startsWith(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  // ================= SEARCH =================

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
      final results =
          await _apiService.getQuotesByCategory(trimmedQuery);

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

      // ================= APP BAR =================

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

              // ================= SEARCH INPUT =================

              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          hintText:
                              'Search by category or keyword...',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),

                        onSubmitted: (value) {
                          _performSearch(value);
                        },

                        onChanged: (value) {
                          _showSuggestions(value);

                          if (value.isEmpty) {
                            _performSearch('');
                          }
                        },
                      ),
                    ),

                    // ================= CLEAR BUTTON =================

                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();

                          setState(() {
                            _suggestions = [];
                            _searchResults = [];
                            _hasSearched = false;
                            _isLoading = false;
                          });
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),

              // ================= SUGGESTIONS =================

              if (_suggestions.isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];

                      return ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.search_rounded,
                          color: AppColors.textSecondary,
                        ),
                        title: Text(
                          suggestion,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
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
                        ? _buildInitialState()
                        : _searchResults.isEmpty
                            ? _buildEmptyState()
                            : ListView.separated(
                                physics:
                                    const BouncingScrollPhysics(),
                                itemCount:
                                    _searchResults.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final quote =
                                      _searchResults[index];

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

  // ================= INITIAL STATE =================

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
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ================= EMPTY STATE =================

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
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// =====================================================
// QUOTE CARD
// =====================================================

class _QuoteCard extends StatelessWidget {
  final String quote;
  final String author;

  const _QuoteCard({
    required this.quote,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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