import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import 'models/quote_model.dart';

class QuoteApiService {
  static const String _baseUrl =
      'https://dummyjson.com/quotes';

  final Random _random = Random();

  // ============================================================
  // MAX QUOTES PER CATEGORY
  // ============================================================

  static const int _categoryQuoteLimit = 30;

  // DummyJSON total quotes
  static const int _totalApiQuotes = 1454;

  // ============================================================
  // CLEAN QUOTE
  // ============================================================

  QuoteModel _cleanQuoteModel(
    QuoteModel quote,
  ) {
    final cleanContent = quote.content
        .replaceAll(
          RegExp(r'["“”‘’`\\]'),
          '',
        )
        .trim();

    return QuoteModel(
      id: quote.id,
      content: cleanContent,
      author: quote.author,
    );
  }

  // ============================================================
  // REMOVE DUPLICATES
  // ============================================================

  List<QuoteModel> _removeDuplicates(
    List<QuoteModel> quotes,
  ) {
    final seen = <String>{};
    final result = <QuoteModel>[];

    for (final quote in quotes) {
      final cleaned = _cleanQuoteModel(quote);

      final key =
          cleaned.content.trim().toLowerCase();

      if (key.isEmpty) {
        continue;
      }

      if (!seen.contains(key)) {
        seen.add(key);
        result.add(cleaned);
      }
    }

    return result;
  }

  // ============================================================
  // RANDOM QUOTE
  // ============================================================

  Future<QuoteModel> fetchRandomQuote() async {
    try {
      final randomId =
          _random.nextInt(_totalApiQuotes) + 1;

      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl/$randomId',
            ),
          )
          .timeout(
            const Duration(milliseconds: 2500),
          );

      if (response.statusCode == 200) {
        final data =
            jsonDecode(response.body);

        return _cleanQuoteModel(
          QuoteModel.fromJson(data),
        );
      }
    } catch (_) {}

    final fallback =
        _getCategoryFallback('faith');

    return fallback[
        _random.nextInt(fallback.length)];
  }

  // ============================================================
  // GET ALL API QUOTES
  // ============================================================

  Future<List<QuoteModel>> fetchAllQuotes() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl?limit=0',
            ),
          )
          .timeout(
            const Duration(milliseconds: 3000),
          );

      if (response.statusCode == 200) {
        final data =
            jsonDecode(response.body);

        final List<dynamic> quotesJson =
            data['quotes'] ?? [];

        if (quotesJson.isNotEmpty) {
          final quotes = quotesJson
              .map(
                (json) =>
                    QuoteModel.fromJson(json),
              )
              .toList();

          return _removeDuplicates(
            quotes,
          );
        }
      }
    } catch (_) {}

    return _getAllFallbackQuotes();
  }

  // ============================================================
  // COMPREHENSIVE SEARCH (ONLINE API + 600+ OFFLINE QUOTES)
  // ============================================================

  Future<List<QuoteModel>> searchQuotes(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return [];

    final List<QuoteModel> results = [];
    final Set<String> seen = {};

    // 1. Live Online API Search
    try {
      final url =
          '$_baseUrl/search?q=${Uri.encodeQueryComponent(cleanQuery)}&limit=50';
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> quotesJson = data['quotes'] ?? [];
        for (final json in quotesJson) {
          final model = _cleanQuoteModel(QuoteModel.fromJson(json));
          if (model.content.isNotEmpty &&
              seen.add(model.content.toLowerCase())) {
            results.add(model);
          }
        }
      }
    } catch (_) {}

    // 2. Intelligent Topic / Keyword Mapping
    final Map<String, List<String>> keywordMap = {
      'faith': [
        'islam',
        'allah',
        'dua',
        'prayer',
        'god',
        'believe',
        'belief',
        'worship',
        'spirit',
        'spiritual',
        'soul',
        'holy',
        'religion',
        'quran',
        'iman',
        'deen'
      ],
      'peace': [
        'calm',
        'quiet',
        'serene',
        'tranquil',
        'relax',
        'silence',
        'harmony',
        'stillness',
        'rest',
        'soothe'
      ],
      'wisdom': [
        'wise',
        'knowledge',
        'learn',
        'lesson',
        'mind',
        'intellect',
        'insight',
        'smart',
        'thought',
        'think',
        'advice'
      ],
      'success': [
        'win',
        'achieve',
        'goal',
        'work',
        'hardwork',
        'effort',
        'career',
        'money',
        'business',
        'rich',
        'victory',
        'champion'
      ],
      'love': [
        'heart',
        'care',
        'affection',
        'romance',
        'compassion',
        'beloved',
        'family',
        'kind'
      ],
      'courage': [
        'brave',
        'fear',
        'strength',
        'strong',
        'bold',
        'hero',
        'fight',
        'stand',
        'confident',
        'confidence'
      ],
      'hope': [
        'bright',
        'tomorrow',
        'future',
        'optimism',
        'light',
        'dream',
        'dreams',
        'wish',
        'shine'
      ],
      'patience': [
        'sabr',
        'wait',
        'endure',
        'calm',
        'perseverance',
        'persist',
        'time',
        'slow'
      ],
      'gratitude': [
        'thanks',
        'thankful',
        'grateful',
        'shukr',
        'blessing',
        'blessed',
        'appreciate',
        'gift'
      ],
      'strength': [
        'power',
        'strong',
        'resilience',
        'tough',
        'invincible',
        'energy',
        'force'
      ],
      'happiness': [
        'happy',
        'joy',
        'smile',
        'laugh',
        'delight',
        'glad',
        'cheerful',
        'positive'
      ],
      'motivation': [
        'inspire',
        'inspiration',
        'motivate',
        'drive',
        'focus',
        'start',
        'action',
        'determination'
      ],
      'friendship': [
        'friend',
        'friends',
        'buddy',
        'companion',
        'loyalty',
        'together',
        'brother'
      ],
      'knowledge': [
        'study',
        'book',
        'read',
        'education',
        'school',
        'learn',
        'skill'
      ],
      'kindness': [
        'kind',
        'help',
        'gentle',
        'generous',
        'giving',
        'share',
        'goodness'
      ],
      'time': [
        'moment',
        'now',
        'today',
        'clock',
        'hour',
        'day',
        'years',
        'passed',
        'early',
        'late'
      ],
      'forgiveness': [
        'forgive',
        'mercy',
        'sorry',
        'apology',
        'pardon',
        'mistake',
        'clean'
      ],
      'truth': [
        'true',
        'honest',
        'honesty',
        'integrity',
        'real',
        'reality',
        'sincere',
        'trust'
      ],
      'future': [
        'destiny',
        'ahead',
        'next',
        'plan',
        'create',
        'build',
        'tomorrow',
        'vision'
      ],
      'life': [
        'alive',
        'living',
        'human',
        'world',
        'journey',
        'experience',
        'nature',
        'live'
      ],
    };

    final allCategoryKeys = [
      'faith',
      'life',
      'wisdom',
      'success',
      'love',
      'peace',
      'courage',
      'hope',
      'patience',
      'gratitude',
      'strength',
      'happiness',
      'motivation',
      'friendship',
      'knowledge',
      'kindness',
      'time',
      'forgiveness',
      'truth',
      'future',
    ];

    // 3. Category match or keyword match in offline database
    for (final category in allCategoryKeys) {
      bool isMatch =
          category.contains(cleanQuery) || cleanQuery.contains(category);
      if (!isMatch && keywordMap.containsKey(category)) {
        final keywords = keywordMap[category]!;
        if (keywords.any(
            (kw) => cleanQuery.contains(kw) || kw.contains(cleanQuery))) {
          isMatch = true;
        }
      }

      if (isMatch) {
        final catQuotes = _getCategoryFallback(category);
        for (final q in catQuotes) {
          if (seen.add(q.content.toLowerCase())) {
            results.add(q);
          }
        }
      }
    }

    // 4. Substring Search across ALL offline quotes (quote text + author)
    final allLocal = _getAllFallbackQuotes();
    for (final q in allLocal) {
      if (q.content.toLowerCase().contains(cleanQuery) ||
          q.author.toLowerCase().contains(cleanQuery)) {
        if (seen.add(q.content.toLowerCase())) {
          results.add(q);
        }
      }
    }

    return results;
  }

  // ============================================================
  // NORMAL PAGINATION
  // ============================================================

  Future<List<QuoteModel>> getQuotes({
    int limit = 20,
    int page = 1,
  }) async {
    final skip = (page - 1) * limit;

    try {
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl?limit=$limit&skip=$skip',
            ),
          )
          .timeout(
            const Duration(seconds: 4),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> quotesJson = data['quotes'] ?? [];

        if (quotesJson.isNotEmpty) {
          final quotes = quotesJson
              .map(
                (json) => QuoteModel.fromJson(json),
              )
              .toList();

          final cleaned = _removeDuplicates(quotes);
          if (cleaned.isNotEmpty) {
            return cleaned;
          }
        }
      }
    } catch (_) {}

    // ============================================================
    // OFFLINE FALLBACK (600+ CURATED QUOTES)
    // ============================================================
    final allFallback = _getAllFallbackQuotes();
    if (allFallback.isEmpty) return [];

    if (skip < allFallback.length) {
      final end = min(skip + limit, allFallback.length);
      return allFallback.sublist(skip, end);
    }

    return [];
  }

  // ============================================================
  // GET CATEGORY QUOTES
  //
  // ONLY 30 QUOTES
  // ============================================================

  Future<List<QuoteModel>> getAllQuotesByCategory(
    String category,
  ) async {
    final cleanCategory =
        category.toLowerCase().trim();

    try {
      final url =
          '$_baseUrl/search?q='
          '${Uri.encodeQueryComponent(cleanCategory)}'
          '&limit=30';

      final response = await http
          .get(
            Uri.parse(url),
          )
          .timeout(
            const Duration(milliseconds: 2500),
          );

      if (response.statusCode == 200) {
        final data =
            jsonDecode(response.body);

        final List<dynamic> quotesJson =
            data['quotes'] ?? [];

        if (quotesJson.isNotEmpty) {
          final quotes = quotesJson
              .map(
                (json) =>
                    QuoteModel.fromJson(json),
              )
              .toList();

          final cleaned =
              _removeDuplicates(quotes);

          if (cleaned.isNotEmpty) {
            // Maximum 30 quotes
            return cleaned
                .take(_categoryQuoteLimit)
                .toList();
          }
        }
      }
    } catch (_) {}

    // API fail ہونے کی صورت میں
    // fallback سے صرف 30 quotes
    return _getCategoryFallback(
      cleanCategory,
    );
  }

  // ============================================================
  // CATEGORY QUOTES
  //
  // EXISTING SCREEN COMPATIBILITY
  // ============================================================

  Future<List<QuoteModel>> getQuotesByCategory(
    String category,
  ) async {
    final quotes =
        await getAllQuotesByCategory(
      category,
    );

    return quotes
        .take(_categoryQuoteLimit)
        .toList();
  }

  // ============================================================
  // CATEGORY PAGINATION
  //
  // KEPT FOR EXISTING CODE
  // ============================================================

  Future<List<QuoteModel>>
      getQuotesByCategoryPage({
    required String category,
    int page = 1,
    int limit = 30,
  }) async {
    if (page < 1) {
      page = 1;
    }

    if (limit < 1) {
      limit = 30;
    }

    final allQuotes =
        await getAllQuotesByCategory(
      category,
    );

    if (allQuotes.isEmpty) {
      return [];
    }

    final start =
        (page - 1) * limit;

    if (start >= allQuotes.length) {
      return [];
    }

    final end = min(
      start + limit,
      allQuotes.length,
    );

    return allQuotes.sublist(
      start,
      end,
    );
  }

  // ============================================================
  // ALL FALLBACK QUOTES
  // ============================================================

  List<QuoteModel> _getAllFallbackQuotes() {
    final categories = [
      'faith',
      'life',
      'wisdom',
      'success',
      'love',
      'peace',
      'courage',
      'hope',
      'patience',
      'gratitude',
      'strength',
      'happiness',
      'motivation',
      'friendship',
      'knowledge',
      'kindness',
      'time',
      'forgiveness',
      'truth',
      'future',
    ];

    final allQuotes =
        <QuoteModel>[];

    for (final category in categories) {
      allQuotes.addAll(
        _getCategoryFallback(category),
      );
    }

    return _removeDuplicates(
      allQuotes,
    );
  }

  // ============================================================
  // CATEGORY FALLBACK
  //
  // EACH CATEGORY = 30 QUOTES
  // ============================================================

  List<QuoteModel> _getCategoryFallback(
    String category,
  ) {
    final Map<String, List<String>>
        categoryData = {

      // ========================================================
      // FAITH
      // ========================================================

      'faith': [
        'Verily, with hardship comes ease.',
        'Do not lose hope, nor be sad.',
        'Faith gives strength during difficult times.',
        'Trust Allah and keep moving forward.',
        'Faith makes the heart peaceful.',
        'Allah is always near to those who remember Him.',
        'Keep your heart connected to Allah.',
        'Never give up on the mercy of Allah.',
        'A faithful heart finds peace in every situation.',
        'Trust the plan of Allah.',
        'Prayer brings peace to the heart.',
        'Faith grows when you remain patient.',
        'Put your worries in the hands of Allah.',
        'A sincere heart is never truly alone.',
        'Hope in Allah should never disappear.',
        'Remember Allah in ease and difficulty.',
        'Faith teaches patience and gratitude.',
        'Let your heart rely upon Allah.',
        'Allah knows what your heart cannot explain.',
        'Every difficulty can bring you closer to Allah.',
        'Keep making dua and keep believing.',
        'A peaceful heart begins with faith.',
        'Allah knows what is best for you.',
        'Patience and faith walk together.',
        'Do good and trust Allah with the result.',
        'Faith turns fear into hope.',
        'Remember that Allah never forgets His servants.',
        'Keep your heart hopeful.',
        'Trust Allah even when the path is unclear.',
        'A strong faith brings lasting peace.',
      ],

      // ========================================================
      // LIFE
      // ========================================================

      'life': [
        'Life is a journey, not a destination.',
        'Every day is a new opportunity.',
        'Life becomes meaningful when we appreciate simple moments.',
        'Keep moving forward one step at a time.',
        'Learn from yesterday and live today.',
        'Every experience teaches something valuable.',
        'Life changes when your perspective changes.',
        'Make today count.',
        'Be thankful for the life you have.',
        'Small moments often become beautiful memories.',
        'Life is full of lessons.',
        'Do not be afraid of a new beginning.',
        'Enjoy the journey.',
        'Choose peace whenever possible.',
        'Your actions shape your future.',
        'Be present in the moment.',
        'Life is easier when you stop comparing yourself to others.',
        'Grow through every experience.',
        'Make room for kindness.',
        'Use your time wisely.',
        'Every morning brings another chance.',
        'Let go of what you cannot change.',
        'Keep learning and keep growing.',
        'Life becomes brighter when gratitude grows.',
        'Be patient with your journey.',
        'Focus on what truly matters.',
        'Create memories, not regrets.',
        'A simple life can be a beautiful life.',
        'Keep your heart hopeful.',
        'There is always something worth appreciating.',
      ],

      // ========================================================
      // WISDOM
      // ========================================================

      'wisdom': [
        'The only true wisdom is knowing that you can always learn more.',
        'Silence can be a source of great strength.',
        'Think before you speak.',
        'Wisdom grows through experience.',
        'A wise person listens before responding.',
        'Knowledge becomes wisdom when it is applied.',
        'Learn from every mistake.',
        'Patience often reveals the best answer.',
        'Choose understanding over judgment.',
        'A calm mind makes better decisions.',
        'Listen carefully and speak thoughtfully.',
        'Wisdom begins with humility.',
        'Every person can teach you something.',
        'Do not rush decisions.',
        'Learn to see beyond appearances.',
        'Good character is a form of wisdom.',
        'Experience is a powerful teacher.',
        'Think deeply before choosing your path.',
        'A wise heart knows when to remain silent.',
        'Seek knowledge throughout your life.',
        'Understanding brings clarity.',
        'Kindness and wisdom work together.',
        'Learn from the past without living in it.',
        'A patient person sees opportunities others miss.',
        'Wisdom teaches balance.',
        'Choose your words carefully.',
        'Growth begins when you accept what you do not know.',
        'Listen more and assume less.',
        'A thoughtful mind creates better choices.',
        'True wisdom creates peace.',
      ],

      // ========================================================
      // SUCCESS
      // ========================================================

      'success': [
        'Success begins with taking the first step.',
        'Consistency creates results.',
        'Believe in your ability to improve.',
        'Small progress is still progress.',
        'Do not fear failure.',
        'Keep working toward your goals.',
        'Success requires patience.',
        'Your effort matters.',
        'Learn from every setback.',
        'Stay focused on your purpose.',
        'Great results take time.',
        'Discipline creates progress.',
        'Keep showing up.',
        'Dreams require action.',
        'Turn challenges into lessons.',
        'Believe in the process.',
        'Do not stop because progress feels slow.',
        'Every achievement starts with an idea.',
        'Work quietly and let your results speak.',
        'Stay committed to your goals.',
        'Success is built one decision at a time.',
        'Be willing to learn.',
        'Keep improving yourself.',
        'Use failure as feedback.',
        'Stay patient with your progress.',
        'Focus on progress, not perfection.',
        'Your future is shaped by your choices.',
        'Keep going when things become difficult.',
        'Hard work creates opportunities.',
        'Never stop growing.',
      ],

      // ========================================================
      // LOVE
      // ========================================================

      'love': [
        'Love begins with kindness.',
        'A caring heart makes ordinary moments meaningful.',
        'Love grows through respect.',
        'Kind words can make a difference.',
        'True care is shown through actions.',
        'Love teaches us to understand others.',
        'A kind heart is a beautiful gift.',
        'Respect makes relationships stronger.',
        'Love grows when trust grows.',
        'Care for people with sincerity.',
        'Kindness is one of the purest forms of love.',
        'Love brings people closer.',
        'A thoughtful gesture can brighten someone’s day.',
        'Good relationships need patience.',
        'Listen with your heart.',
        'Respect every person you meet.',
        'Love is shown through compassion.',
        'A caring heart notices the little things.',
        'Be gentle with others.',
        'Sincere love brings peace.',
        'Forgiveness can strengthen relationships.',
        'Appreciate the people who care for you.',
        'Kindness makes love stronger.',
        'Treat others with dignity.',
        'Love grows through understanding.',
        'Be patient with the people around you.',
        'A peaceful heart gives love freely.',
        'Care without expecting something in return.',
        'Gratitude makes relationships beautiful.',
        'Let kindness guide your heart.',
      ],

      // ========================================================
      // PEACE
      // ========================================================

      'peace': [
        'Peace begins within the heart.',
        'Choose calm over unnecessary conflict.',
        'A peaceful mind sees things clearly.',
        'Let go of what you cannot control.',
        'Silence can bring peace.',
        'Protect your inner peace.',
        'Forgiveness can bring peace to the heart.',
        'Take time to breathe and reflect.',
        'Peace grows through understanding.',
        'Do not carry every problem in your heart.',
        'A calm heart makes better choices.',
        'Choose kindness over anger.',
        'Peace requires patience.',
        'Let your heart rest.',
        'Avoid unnecessary arguments.',
        'A peaceful life begins with peaceful choices.',
        'Give yourself time to think.',
        'Keep your surroundings positive.',
        'Do not allow temporary problems to steal your peace.',
        'Gratitude creates peace.',
        'A gentle heart creates harmony.',
        'Choose understanding before judgment.',
        'Peace grows when expectations become balanced.',
        'Keep your mind calm.',
        'Release unnecessary worries.',
        'Be patient with yourself.',
        'A peaceful heart is a strong heart.',
        'Seek solutions instead of conflict.',
        'Let kindness lead your actions.',
        'Peace is worth protecting.',
      ],

      // ========================================================
      // COURAGE
      // ========================================================

      'courage': [
        'Courage is taking action despite fear.',
        'Be brave enough to begin again.',
        'Every difficult step can make you stronger.',
        'Courage grows through experience.',
        'Do not let fear make your decisions.',
        'Take one small step forward.',
        'Believe that you can learn.',
        'Difficult moments can teach courage.',
        'Stand firmly for what is right.',
        'Keep going when the path becomes difficult.',
        'Bravery begins with believing in yourself.',
        'Do not be afraid of change.',
        'Face challenges with patience.',
        'Courage requires persistence.',
        'A brave heart keeps hope alive.',
        'Learn to face uncertainty calmly.',
        'Every new beginning requires courage.',
        'Do what is right even when it is difficult.',
        'Strength grows when you face challenges.',
        'Keep your heart strong.',
        'Do not give fear control over your choices.',
        'Courage can begin with one decision.',
        'Be patient with your progress.',
        'Believe in your ability to improve.',
        'Face tomorrow with hope.',
        'Challenges do not define your future.',
        'Keep moving forward.',
        'A strong heart does not give up easily.',
        'Choose courage over unnecessary fear.',
        'You can grow through difficult experiences.',
      ],

      // ========================================================
      // HOPE
      // ========================================================

      'hope': [
        'Hope gives light to difficult moments.',
        'Never stop believing in better days.',
        'Every morning brings a new opportunity.',
        'Hope keeps the heart strong.',
        'Difficult times do not last forever.',
        'Keep looking forward.',
        'A hopeful heart finds possibilities.',
        'Do not give up on tomorrow.',
        'There is always room for a new beginning.',
        'Hope grows when gratitude grows.',
        'Keep your heart positive.',
        'Better days can come with patience.',
        'Believe that things can improve.',
        'Hope gives courage to continue.',
        'Do not let temporary problems define your future.',
        'Keep walking toward the light.',
        'A hopeful mind sees opportunities.',
        'Tomorrow can bring something beautiful.',
        'Keep believing in good possibilities.',
        'Hope makes difficult journeys easier.',
        'Be patient with your journey.',
        'Let hope guide your choices.',
        'Every challenge can have a lesson.',
        'Keep your dreams alive.',
        'A hopeful heart does not give up easily.',
        'Look ahead with confidence.',
        'There is always another chance to begin.',
        'Choose hope over unnecessary worry.',
        'Stay patient and positive.',
        'Hope is a powerful source of strength.',
      ],

      // ========================================================
      // PATIENCE
      // ========================================================

      'patience': [
        'Patience is beautiful.',
        'Good things often take time.',
        'Patience gives wisdom to difficult moments.',
        'Learn to wait without losing hope.',
        'Stay calm while life unfolds.',
        'Patience strengthens the heart.',
        'Do not rush what needs time.',
        'Trust the process.',
        'A patient heart sees possibilities.',
        'Waiting can teach valuable lessons.',
        'Patience and gratitude create peace.',
        'Keep faith while you wait.',
        'Slow progress is still progress.',
        'Give yourself time to grow.',
        'Not everything needs an immediate answer.',
        'Patience helps us make better decisions.',
        'Stay calm during difficult seasons.',
        'Good results require consistency.',
        'Learn to accept the timing of life.',
        'Patience is a form of strength.',
        'Keep going while you wait.',
        'Do not lose hope because something takes time.',
        'Let experiences teach you patience.',
        'A calm heart can wait wisely.',
        'Give your goals time to grow.',
        'Be patient with yourself.',
        'Be patient with others.',
        'Every season has its own timing.',
        'Patience creates inner peace.',
        'Trust that growth takes time.',
      ],

      // ========================================================
      // GRATITUDE
      // ========================================================

      'gratitude': [
        'If you are grateful, I will surely give you more.',
        'Gratitude turns what we have into enough.',
        'Be thankful for the little things.',
        'A grateful heart finds more joy.',
        'Appreciate what you already have.',
        'Gratitude changes perspective.',
        'Thankfulness creates peace.',
        'Notice the blessings around you.',
        'A thankful heart is a peaceful heart.',
        'Be grateful for another day.',
        'Appreciate the people who support you.',
        'Gratitude makes ordinary moments special.',
        'Count your blessings.',
        'Thankfulness creates happiness.',
        'Look for something good every day.',
        'A grateful mind sees abundance.',
        'Appreciate every small blessing.',
        'Gratitude brings positivity.',
        'Be thankful for lessons as well as blessings.',
        'A thankful heart stays hopeful.',
        'Remember the good things in your life.',
        'Gratitude makes the heart lighter.',
        'Give thanks for every opportunity.',
        'Appreciate simple moments.',
        'Thankfulness strengthens relationships.',
        'Gratitude helps us notice beauty.',
        'Be grateful for progress.',
        'A grateful heart needs less comparison.',
        'Choose gratitude every day.',
        'Let thankfulness guide your heart.',
      ],

      // ========================================================
      // STRENGTH
      // ========================================================

      'strength': [
        'Strength grows through challenges.',
        'A strong mind stays calm in difficult moments.',
        'Inner strength begins with self-belief.',
        'You can become stronger through experience.',
        'Strength requires patience.',
        'Keep going even when progress is slow.',
        'Challenges can build resilience.',
        'Believe in your ability to learn.',
        'A calm heart is a strong heart.',
        'Do not underestimate your ability to grow.',
        'Strength comes from persistence.',
        'Every difficult lesson can make you wiser.',
        'Keep your heart hopeful.',
        'Stand strong during difficult seasons.',
        'Learn to recover from setbacks.',
        'Strength grows when you keep trying.',
        'A positive mindset creates resilience.',
        'Do not let temporary problems define you.',
        'Keep moving forward.',
        'Believe that you can improve.',
        'Strong people also know when to rest.',
        'Patience is a form of strength.',
        'Kindness can be a form of strength.',
        'Courage creates strength.',
        'Faith gives strength to the heart.',
        'Every challenge can teach resilience.',
        'Keep your mind focused.',
        'Choose hope during difficult moments.',
        'Your effort can make you stronger.',
        'Keep building your inner strength.',
      ],

      // ========================================================
      // HAPPINESS
      // ========================================================

      'happiness': [
        'Happiness is found in simple moments.',
        'Choose joy whenever you can.',
        'A grateful heart is often a happy heart.',
        'Happiness grows when shared.',
        'Find something beautiful in every day.',
        'Enjoy the little things.',
        'Smile at the small blessings.',
        'Happiness begins with gratitude.',
        'Choose positive thoughts.',
        'Spend time with people who bring peace.',
        'A peaceful heart can find happiness anywhere.',
        'Appreciate today.',
        'Do not wait for perfect moments.',
        'Create happiness through kindness.',
        'Celebrate small achievements.',
        'Enjoy your journey.',
        'Happiness grows through meaningful moments.',
        'Be thankful for what you have.',
        'Let go of unnecessary comparison.',
        'Find joy in learning.',
        'Make time for things you enjoy.',
        'Kindness can create happiness.',
        'A simple life can be a happy life.',
        'Choose peace over unnecessary stress.',
        'Be present in beautiful moments.',
        'Happiness often begins with perspective.',
        'Share a smile with someone.',
        'Notice the good around you.',
        'Keep your heart grateful.',
        'Let joy grow through gratitude.',
      ],

      // ========================================================
      // MOTIVATION
      // ========================================================

      'motivation': [
        'It always seems impossible until it is done.',
        'Keep going.',
        'Great things begin with small steps.',
        'Believe in your potential.',
        'Do not stop because progress is slow.',
        'Your effort matters.',
        'Start where you are.',
        'Keep learning.',
        'Turn your goals into action.',
        'Progress begins with consistency.',
        'Believe that you can improve.',
        'Stay focused.',
        'Keep moving forward.',
        'Every step matters.',
        'Do not wait for perfect conditions.',
        'Use your time wisely.',
        'Keep your purpose clear.',
        'Work toward something meaningful.',
        'Learn from mistakes.',
        'Do not fear starting again.',
        'Be consistent with your efforts.',
        'Small actions create big changes.',
        'Keep your mindset positive.',
        'Stay patient with yourself.',
        'Do not give up on your goals.',
        'Your future depends on today’s choices.',
        'Keep pushing forward with patience.',
        'Believe in the process.',
        'Make today productive.',
        'Never stop growing.',
      ],

      // ========================================================
      // FRIENDSHIP
      // ========================================================

      'friendship': [
        'A true friend brings peace to your heart.',
        'Friendship grows through trust.',
        'Good friends support each other.',
        'A kind friend is a valuable blessing.',
        'True friendship needs honesty.',
        'Good friends listen without judgment.',
        'Friendship becomes stronger through respect.',
        'Appreciate the people who stand by you.',
        'A good friend celebrates your progress.',
        'Friendship requires patience.',
        'Kindness strengthens friendships.',
        'Trust is the foundation of friendship.',
        'A true friend wants the best for you.',
        'Good friendships create beautiful memories.',
        'Be the kind of friend you wish to have.',
        'Listen to your friends with care.',
        'Respect your friends’ feelings.',
        'Friendship grows through shared experiences.',
        'A sincere friend brings comfort.',
        'Good friends encourage growth.',
        'Friendship is built through small acts of kindness.',
        'Appreciate loyal people.',
        'Be honest with your friends.',
        'Forgive small mistakes.',
        'Support your friends during difficult times.',
        'Celebrate your friends’ achievements.',
        'Good friendship creates happiness.',
        'Treat friendship as a blessing.',
        'Keep sincere friendships close.',
        'A kind friend can brighten an ordinary day.',
      ],

      // ========================================================
      // KNOWLEDGE
      // ========================================================

      'knowledge': [
        'Knowledge gives you the power to understand.',
        'Learning never truly ends.',
        'The more you learn, the more you discover.',
        'Knowledge grows when it is shared.',
        'Ask questions and keep learning.',
        'Every experience can teach something.',
        'Read something useful every day.',
        'Learning creates new possibilities.',
        'Knowledge helps us make better decisions.',
        'Stay curious.',
        'Never be afraid to learn something new.',
        'Education opens doors.',
        'Learning requires patience.',
        'Experience adds depth to knowledge.',
        'Good questions lead to good learning.',
        'Share knowledge with kindness.',
        'Learn from people around you.',
        'Knowledge grows through practice.',
        'Keep improving your skills.',
        'Learning makes the mind stronger.',
        'Be curious about the world.',
        'Listen to different perspectives.',
        'Knowledge creates confidence.',
        'Learn from your mistakes.',
        'Keep an open mind.',
        'Never stop asking why.',
        'Learning is a lifelong journey.',
        'Read, reflect, and practice.',
        'Knowledge becomes useful when applied.',
        'Keep your mind curious.',
      ],

      // ========================================================
      // KINDNESS
      // ========================================================

      'kindness': [
        'Kindness costs nothing but means everything.',
        'One kind word can change someone’s day.',
        'Be kind whenever possible.',
        'Kindness makes the world brighter.',
        'A small act of kindness can have a big impact.',
        'Treat people with respect.',
        'A gentle word can bring comfort.',
        'Help others when you can.',
        'Kindness creates connection.',
        'Be patient with people.',
        'Listen when someone needs to talk.',
        'A smile can brighten someone’s day.',
        'Choose compassion.',
        'Kindness creates positive energy.',
        'Small good actions matter.',
        'Be thoughtful in your words.',
        'Respect everyone you meet.',
        'Give encouragement freely.',
        'Kindness strengthens communities.',
        'Help without expecting praise.',
        'Be gentle with yourself and others.',
        'Compassion creates peace.',
        'A kind heart notices when others need help.',
        'Choose understanding over judgment.',
        'Kindness is always worth giving.',
        'Make someone feel valued.',
        'Speak with care.',
        'Good actions inspire more good actions.',
        'Let kindness guide your choices.',
        'Make kindness a daily habit.',
      ],

      // ========================================================
      // TIME
      // ========================================================

      'time': [
        'Time you enjoy is never truly wasted.',
        'Time is precious.',
        'Use your time wisely.',
        'Lost time cannot be recovered.',
        'Every moment is an opportunity.',
        'Do not postpone what truly matters.',
        'Value the present moment.',
        'Time teaches valuable lessons.',
        'Good things take time.',
        'Be patient with your journey.',
        'Spend time with people who matter.',
        'Make time for what is important.',
        'Every day is valuable.',
        'Do not waste today worrying about tomorrow.',
        'Use your time to grow.',
        'Moments become memories.',
        'Time changes many things.',
        'Be present while life is happening.',
        'Learn to prioritize your time.',
        'Give yourself time to rest.',
        'Time can heal and teach.',
        'Make every day meaningful.',
        'Do not wait forever to begin.',
        'Use today wisely.',
        'Time is one of life’s greatest gifts.',
        'Create memories with your time.',
        'Respect other people’s time.',
        'Balance work and rest.',
        'Enjoy the moment.',
        'Let time work with patience.',
      ],

      // ========================================================
      // FORGIVENESS
      // ========================================================

      'forgiveness': [
        'Forgiveness brings peace to the heart.',
        'Let go of what you cannot change.',
        'Forgiveness can be a gift to yourself.',
        'A forgiving heart finds peace.',
        'Healing can begin with forgiveness.',
        'Do not carry unnecessary anger.',
        'Learn from mistakes and move forward.',
        'Forgiveness requires courage.',
        'Let your heart choose peace.',
        'Release old resentment.',
        'Everyone makes mistakes.',
        'Forgive when it is appropriate.',
        'Choose healing over bitterness.',
        'Peace grows when anger is released.',
        'Do not let the past control your present.',
        'Learn the lesson and move forward.',
        'Forgiveness creates emotional freedom.',
        'A peaceful heart does not hold unnecessary grudges.',
        'Give yourself permission to grow.',
        'Let difficult experiences teach you.',
        'Choose understanding when possible.',
        'Healing takes time.',
        'Be patient with yourself.',
        'Forgiveness can create a new beginning.',
        'Do not allow anger to define you.',
        'Peace is more valuable than resentment.',
        'Learn to release what hurts you.',
        'Growth often follows difficult experiences.',
        'Choose peace when you can.',
        'Let your heart heal with patience.',
      ],

      // ========================================================
      // TRUTH
      // ========================================================

      'truth': [
        'Truth needs no decoration.',
        'Honesty builds trust.',
        'Always choose truth.',
        'Truth brings clarity.',
        'Integrity means doing what is right.',
        'Be honest with yourself.',
        'Truth creates strong relationships.',
        'Honesty requires courage.',
        'Speak the truth with kindness.',
        'Do not hide from reality.',
        'Truth helps us learn.',
        'A truthful heart is peaceful.',
        'Keep your promises.',
        'Let your actions match your words.',
        'Integrity matters even when nobody is watching.',
        'Choose honesty over convenience.',
        'Truth can guide good decisions.',
        'Be sincere in your intentions.',
        'Honesty creates respect.',
        'Do not fear constructive truth.',
        'Learn to accept reality.',
        'Truth builds lasting trust.',
        'Speak carefully and honestly.',
        'Keep your character strong.',
        'Be truthful without being harsh.',
        'Honesty is a valuable quality.',
        'Let integrity guide you.',
        'A clear conscience brings peace.',
        'Choose what is right.',
        'Truth creates clarity in difficult situations.',
      ],

      // ========================================================
      // FUTURE
      // ========================================================

      'future': [
        'The future begins with what you do today.',
        'Look forward with hope.',
        'Every day is a chance to create a better future.',
        'Your future is built one choice at a time.',
        'Believe in the possibilities ahead.',
        'Small actions shape tomorrow.',
        'Prepare today for better opportunities.',
        'Your choices create your direction.',
        'Keep learning for your future.',
        'Do not fear a new beginning.',
        'The future can change with effort.',
        'Build your future with patience.',
        'Keep your goals clear.',
        'Hope makes the future brighter.',
        'Every new day is another opportunity.',
        'Plan wisely and remain flexible.',
        'Your future deserves your effort.',
        'Learn from the past and move forward.',
        'Keep improving yourself.',
        'Believe that growth is possible.',
        'Create opportunities through action.',
        'Do not let yesterday control tomorrow.',
        'Stay focused on what matters.',
        'Your future starts with today.',
        'Be patient with your progress.',
        'Keep moving toward meaningful goals.',
        'Choose hope for tomorrow.',
        'Every decision can shape your path.',
        'Work for the future you want.',
        'Keep believing in better possibilities.',
      ],
    };

    final contents =
        categoryData[category] ??
            categoryData['faith']!;

    final List<QuoteModel> quotes = [];

    for (int i = 0;
        i < contents.length;
        i++) {
      quotes.add(
        QuoteModel(
          id:
              (category.hashCode.abs() % 100000) +
                  i +
                  1,
          content:
              contents[i],
          author:
              'Soul Voice',
        ),
      );
    }

    // Safety: ہمیشہ maximum 30
    return quotes
        .take(_categoryQuoteLimit)
        .toList();
  }
}