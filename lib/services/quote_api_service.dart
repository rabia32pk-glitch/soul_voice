import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'models/quote_model.dart';

class QuoteApiService {
  static const String _baseUrl = 'https://dummyjson.com/quotes';
  final Random _random = Random();

  // Total quotes available on DummyJSON API is 1453
  static const int _totalApiQuotes = 1453;

  // 1. Dynamic Random Quote
  Future<QuoteModel> fetchRandomQuote() async {
    try {
      final randomId = _random.nextInt(_totalApiQuotes) + 1;
      final response = await http
          .get(Uri.parse('$_baseUrl/$randomId'))
          .timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return QuoteModel.fromJson(data);
      }
    } catch (e) {
      // Fallback on failure
    }

    final fallbackList = _getCategoryFallback('general');
    return fallbackList[_random.nextInt(fallbackList.length)];
  }

  // 2. Fetch All 1400+ Quotes at Once (Unlimited Mode)
  Future<List<QuoteModel>> fetchAllQuotes() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl?limit=0'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> quotesJson = data['quotes'] ?? [];
        if (quotesJson.isNotEmpty) {
          return quotesJson.map((json) => QuoteModel.fromJson(json)).toList();
        }
      }
    } catch (e) {
      // Fallback on failure
    }

    return _getAllFallbackQuotes();
  }

  // 3. Featured Quotes with True Unlimited Scroll Support
  Future<List<QuoteModel>> getQuotes({int limit = 10, int page = 1}) async {
    // True infinite page rotation
    final totalPages = (_totalApiQuotes / limit).ceil();
    final effectivePage = ((page - 1) % totalPages) + 1;
    final skip = (effectivePage - 1) * limit;

    try {
      final response = await http
          .get(Uri.parse('$_baseUrl?limit=$limit&skip=$skip'))
          .timeout(const Duration(seconds: 7));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> quotesJson = data['quotes'] ?? [];
        if (quotesJson.isNotEmpty) {
          final list = quotesJson
              .map((json) => QuoteModel.fromJson(json))
              .toList();
          
          // Inject dynamic fallback items when looping back to keep content fresh
          if (page > totalPages) {
            list.shuffle(_random);
          }
          return list;
        }
      }
    } catch (e) {
      // Fallback on Network Error
    }

    // Unlimited Local Fallback Rotation on API Failure
    final allFallback = _getAllFallbackQuotes();
    allFallback.shuffle(_random);
    final startIndex = ((page - 1) * limit) % allFallback.length;
    final endIndex = (startIndex + limit) > allFallback.length
        ? allFallback.length
        : (startIndex + limit);

    return allFallback.sublist(startIndex, endIndex);
  }

  // 4. Category Specific Quotes List
  Future<List<QuoteModel>> getQuotesByCategory(String category) async {
    final cleanCategory = category.toLowerCase().trim().replaceAll(' ', '_');

    try {
      final url = '$_baseUrl/search?q=$cleanCategory';
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> quotesJson = data['quotes'] ?? [];

        if (quotesJson.length >= 3) {
          return quotesJson.map((json) => QuoteModel.fromJson(json)).toList();
        }
      }
    } catch (e) {
      // Fallback
    }

    return _getCategoryFallback(cleanCategory);
  }

  // Helper method to combine all fallback lists
  List<QuoteModel> _getAllFallbackQuotes() {
    final List<QuoteModel> allQuotes = [];
    final categories = [
      'faith', 'life', 'wisdom', 'success', 'love', 'peace', 'hope',
      'gratitude', 'motivation', 'hard_work', 'self_care', 'patience',
      'friendship', 'family', 'heartbreak', 'trust', 'time', 'morning',
      'night', 'mindset'
    ];

    for (var cat in categories) {
      allQuotes.addAll(_getCategoryFallback(cat));
    }
    return allQuotes;
  }

  // Complete 20 Categories Local Dataset (5 Quotes Each)
  List<QuoteModel> _getCategoryFallback(String category) {
    final Map<String, List<QuoteModel>> categoryData = {
      'faith': [
        QuoteModel(
          id: 101,
          content: "Verily, with hardship comes ease.",
          author: "Quran (94:6)",
        ),
        QuoteModel(
          id: 102,
          content: "Do not lose hope, nor be sad.",
          author: "Quran (3:139)",
        ),
        QuoteModel(
          id: 103,
          content:
              "Faith is taking the first step even when you don't see the whole staircase.",
          author: "Martin Luther King Jr.",
        ),
        QuoteModel(
          id: 104,
          content: "Trust in Allah, but tie your camel.",
          author: "Prophet Muhammad (PBUH)",
        ),
        QuoteModel(
          id: 105,
          content: "Faith does not make things easy, it makes them possible.",
          author: "Luke 1:37",
        ),
      ],
      'life': [
        QuoteModel(
          id: 201,
          content: "Life is what happens when you're busy making other plans.",
          author: "John Lennon",
        ),
        QuoteModel(
          id: 202,
          content: "Get busy living or get busy dying.",
          author: "Stephen King",
        ),
        QuoteModel(
          id: 203,
          content: "The purpose of our lives is to be happy.",
          author: "Dalai Lama",
        ),
        QuoteModel(
          id: 204,
          content:
              "Life is 10% what happens to you and 90% how you react to it.",
          author: "Charles R. Swindoll",
        ),
        QuoteModel(
          id: 205,
          content:
              "In three words I can sum up everything I've learned about life: it goes on.",
          author: "Robert Frost",
        ),
      ],
      'wisdom': [
        QuoteModel(
          id: 301,
          content: "The only true wisdom is in knowing you know nothing.",
          author: "Socrates",
        ),
        QuoteModel(
          id: 302,
          content: "Silence is a source of great strength.",
          author: "Lao Tzu",
        ),
        QuoteModel(
          id: 303,
          content:
              "The best among you are those who have the best manners and character.",
          author: "Prophet Muhammad (PBUH)",
        ),
        QuoteModel(
          id: 304,
          content: "Turn your wounds into wisdom.",
          author: "Oprah Winfrey",
        ),
        QuoteModel(
          id: 305,
          content: "Knowing yourself is the beginning of all wisdom.",
          author: "Aristotle",
        ),
      ],
      'success': [
        QuoteModel(
          id: 401,
          content:
              "Success is not final, failure is not fatal: it is the courage to continue that counts.",
          author: "Winston Churchill",
        ),
        QuoteModel(
          id: 402,
          content: "The way to get started is to quit talking and begin doing.",
          author: "Walt Disney",
        ),
        QuoteModel(
          id: 403,
          content:
              "Don't let the fear of losing be greater than the excitement of winning.",
          author: "Robert Kiyosaki",
        ),
        QuoteModel(
          id: 404,
          content:
              "Success usually comes to those who are too busy to be looking for it.",
          author: "Henry David Thoreau",
        ),
        QuoteModel(
          id: 405,
          content: "Opportunities don't happen. You create them.",
          author: "Chris Grosser",
        ),
      ],
      'love': [
        QuoteModel(
          id: 501,
          content: "The best thing to hold onto in life is each other.",
          author: "Audrey Hepburn",
        ),
        QuoteModel(
          id: 502,
          content: "Love all, trust a few, do wrong to none.",
          author: "William Shakespeare",
        ),
        QuoteModel(
          id: 503,
          content: "Where there is love there is life.",
          author: "Mahatma Gandhi",
        ),
        QuoteModel(
          id: 504,
          content: "Spread love everywhere you go.",
          author: "Mother Teresa",
        ),
        QuoteModel(
          id: 505,
          content:
              "You know you're in love when you can't fall asleep because reality is finally better than your dreams.",
          author: "Dr. Seuss",
        ),
      ],
      'peace': [
        QuoteModel(
          id: 601,
          content: "Peace comes from within. Do not seek it without.",
          author: "Buddha",
        ),
        QuoteModel(
          id: 602,
          content:
              "When the power of love overcomes the love of power, the world will know peace.",
          author: "Jimi Hendrix",
        ),
        QuoteModel(
          id: 603,
          content: "If you want peace, stop fighting.",
          author: "Unknown",
        ),
        QuoteModel(
          id: 604,
          content:
              "Peace is not absence of conflict, it is the ability to handle conflict.",
          author: "Ronald Reagan",
        ),
        QuoteModel(
          id: 605,
          content: "Nobody can bring you peace but yourself.",
          author: "Ralph Waldo Emerson",
        ),
      ],
      'hope': [
        QuoteModel(
          id: 701,
          content:
              "Hope is being able to see that there is light despite all of the darkness.",
          author: "Desmond Tutu",
        ),
        QuoteModel(
          id: 702,
          content:
              "We must accept finite disappointment, but never lose infinite hope.",
          author: "Martin Luther King Jr.",
        ),
        QuoteModel(
          id: 703,
          content: "Hope is a waking dream.",
          author: "Aristotle",
        ),
        QuoteModel(
          id: 704,
          content:
              "There is always hope, even when your brain tells you there isn't.",
          author: "John Green",
        ),
        QuoteModel(
          id: 705,
          content: "May your choices reflect your hopes, not your fears.",
          author: "Nelson Mandela",
        ),
      ],
      'gratitude': [
        QuoteModel(
          id: 801,
          content: "If you are grateful, I will surely give you more.",
          author: "Quran (14:7)",
        ),
        QuoteModel(
          id: 802,
          content: "Gratitude turns what we have into enough.",
          author: "Aesop",
        ),
        QuoteModel(
          id: 803,
          content:
              "When you are grateful, fear disappears and abundance appears.",
          author: "Tony Robbins",
        ),
        QuoteModel(
          id: 804,
          content:
              "Gratitude is the fairest blossom which springs from the soul.",
          author: "Henry Ward Beecher",
        ),
        QuoteModel(
          id: 805,
          content:
              "Enjoy the little things, for one day you may look back and realize they were the big things.",
          author: "Robert Brault",
        ),
      ],
      'motivation': [
        QuoteModel(
          id: 901,
          content: "It always seems impossible until it's done.",
          author: "Nelson Mandela",
        ),
        QuoteModel(
          id: 902,
          content: "Don't watch the clock; do what it does. Keep going.",
          author: "Sam Levenson",
        ),
        QuoteModel(
          id: 903,
          content:
              "Push yourself, because no one else is going to do it for you.",
          author: "Unknown",
        ),
        QuoteModel(
          id: 904,
          content: "Great things never come from comfort zones.",
          author: "Roy T. Bennett",
        ),
        QuoteModel(
          id: 905,
          content: "Dream it. Wish it. Do it.",
          author: "Unknown",
        ),
      ],
      'hard_work': [
        QuoteModel(
          id: 1001,
          content: "Hard work beats talent when talent doesn't work hard.",
          author: "Tim Notke",
        ),
        QuoteModel(
          id: 1002,
          content:
              "There are no secrets to success. It is the result of preparation, hard work, and learning from failure.",
          author: "Colin Powell",
        ),
        QuoteModel(
          id: 1003,
          content:
              "A dream does not become reality through magic; it takes sweat, determination, and hard work.",
          author: "Colin Powell",
        ),
        QuoteModel(
          id: 1004,
          content: "Work hard in silence, let your success be your noise.",
          author: "Frank Ocean",
        ),
        QuoteModel(
          id: 1005,
          content: "Strive not to be a success, but rather to be of value.",
          author: "Albert Einstein",
        ),
      ],
      'self_care': [
        QuoteModel(
          id: 1101,
          content: "Self-care is how you take your power back.",
          author: "Lalah Delia",
        ),
        QuoteModel(
          id: 1102,
          content:
              "Nurturing yourself is not selfish, it's essential to your survival and your well-being.",
          author: "Renee Peterson Trudeau",
        ),
        QuoteModel(
          id: 1103,
          content: "Talk to yourself like you would to someone you love.",
          author: "Brené Brown",
        ),
        QuoteModel(
          id: 1104,
          content:
              "Almost everything will work again if you unplug it for a few minutes, including you.",
          author: "Anne Lamott",
        ),
        QuoteModel(
          id: 1105,
          content:
              "An empty lantern provides no light. Self-care is the fuel that allows your light to shine brightly.",
          author: "Unknown",
        ),
      ],
      'patience': [
        QuoteModel(
          id: 1201,
          content: "Patience is beautiful.",
          author: "Quran (12:18)",
        ),
        QuoteModel(
          id: 1202,
          content:
              "Patience is not the ability to wait, but the ability to keep a good attitude while waiting.",
          author: "Joyce Meyer",
        ),
        QuoteModel(
          id: 1203,
          content: "Adopt the pace of nature: her secret is patience.",
          author: "Ralph Waldo Emerson",
        ),
        QuoteModel(
          id: 1204,
          content:
              "Patience, persistence and perspiration make an unbeatable combination for success.",
          author: "Napoleon Hill",
        ),
        QuoteModel(
          id: 1205,
          content: "Trees that are slow to grow bear the best fruit.",
          author: "Molière",
        ),
      ],
      'friendship': [
        QuoteModel(
          id: 1301,
          content:
              "A real friend is one who walks in when the rest of the world walks out.",
          author: "Walter Winchell",
        ),
        QuoteModel(
          id: 1302,
          content:
              "Friendship is the only cement that will ever hold the world together.",
          author: "Woodrow Wilson",
        ),
        QuoteModel(
          id: 1303,
          content:
              "A person is upon the religion of his best friend, so let one of you look at whom he befriends.",
          author: "Prophet Muhammad (PBUH)",
        ),
        QuoteModel(
          id: 1304,
          content:
              "True friendship comes when the silence between two people is comfortable.",
          author: "David Tyson",
        ),
        QuoteModel(
          id: 1305,
          content: "Friends are the family you choose.",
          author: "Jess C. Scott",
        ),
      ],
      'family': [
        QuoteModel(
          id: 1401,
          content: "Family is not an important thing. It's everything.",
          author: "Michael J. Fox",
        ),
        QuoteModel(
          id: 1402,
          content: "The love of family is life's greatest blessing.",
          author: "Unknown",
        ),
        QuoteModel(
          id: 1403,
          content: "Paradise lies under the feet of mothers.",
          author: "Prophet Muhammad (PBUH)",
        ),
        QuoteModel(
          id: 1404,
          content: "Rejoice with your family in the beautiful land of life.",
          author: "Albert Einstein",
        ),
        QuoteModel(
          id: 1405,
          content: "Family means no one gets left behind or forgotten.",
          author: "David Ogden Stiers",
        ),
      ],
      'heartbreak': [
        QuoteModel(
          id: 1501,
          content:
              "The emotion that can break your heart is sometimes the very one that heals it.",
          author: "Nicholas Sparks",
        ),
        QuoteModel(
          id: 1502,
          content:
              "Hearts will never be practical until they can be made unbreakable.",
          author: "Wizard of Oz",
        ),
        QuoteModel(
          id: 1503,
          content: "With time the heart heals, and the soul grows stronger.",
          author: "Unknown",
        ),
        QuoteModel(
          id: 1504,
          content:
              "Healing doesn't mean the damage never existed. It means the damage no longer controls our lives.",
          author: "Akshay Dubey",
        ),
        QuoteModel(
          id: 1505,
          content:
              "Sometimes good things fall apart so better things can fall together.",
          author: "Marilyn Monroe",
        ),
      ],
      'trust': [
        QuoteModel(
          id: 1601,
          content:
              "Trust in the Lord with all your heart and lean not on your own understanding.",
          author: "Proverbs 3:5",
        ),
        QuoteModel(
          id: 1602,
          content:
              "Trust takes years to build, seconds to break, and forever to repair.",
          author: "Unknown",
        ),
        QuoteModel(
          id: 1603,
          content:
              "The best way to find out if you can trust somebody is to trust them.",
          author: "Ernest Hemingway",
        ),
        QuoteModel(
          id: 1604,
          content: "Trust starts with truth and ends with truth.",
          author: "Santosh Kalwar",
        ),
        QuoteModel(
          id: 1605,
          content:
              "When Allah puts a hardship in your path, trust that He is preparing you for greatness.",
          author: "Unknown",
        ),
      ],
      'time': [
        QuoteModel(
          id: 1701,
          content: "Time you enjoy wasting is not wasted time.",
          author: "John Lennon",
        ),
        QuoteModel(
          id: 1702,
          content: "The two most powerful warriors are patience and time.",
          author: "Leo Tolstoy",
        ),
        QuoteModel(
          id: 1703,
          content:
              "Time is a created thing. To say 'I don't have time' is to say 'I don't want to.'",
          author: "Lao Tzu",
        ),
        QuoteModel(
          id: 1704,
          content: "Lost time is never found again.",
          author: "Benjamin Franklin",
        ),
        QuoteModel(
          id: 1705,
          content:
              "Your time is limited, so don't waste it living someone else's life.",
          author: "Steve Jobs",
        ),
      ],
      'morning': [
        QuoteModel(
          id: 1801,
          content:
              "Every morning brings new potential, but if you dwell on the misfortunes of the day before, you tend to overlook tremendous opportunities.",
          author: "Harvey Mackay",
        ),
        QuoteModel(
          id: 1802,
          content:
              "Write it on your heart that every day is the best day in the year.",
          author: "Ralph Waldo Emerson",
        ),
        QuoteModel(
          id: 1803,
          content:
              "When you arise in the morning think of what a privilege it is to be alive, to think, to enjoy, to love.",
          author: "Marcus Aurelius",
        ),
        QuoteModel(
          id: 1804,
          content:
              "Morning is an important time of day, because how you spend your morning can often tell you what kind of day you are going to have.",
          author: "Lemony Snicket",
        ),
        QuoteModel(
          id: 1805,
          content: "An early-morning walk is a blessing for the whole day.",
          author: "Henry David Thoreau",
        ),
      ],
      'night': [
        QuoteModel(
          id: 1901,
          content:
              "The night is more alive and more richly colored than the day.",
          author: "Vincent van Gogh",
        ),
        QuoteModel(
          id: 1902,
          content:
              "Night is the wonderful opportunity to take rest, to forgive, to smile, to get ready for all the battles that you have to fight tomorrow.",
          author: "Allen Ginsberg",
        ),
        QuoteModel(
          id: 1903,
          content:
              "Day is over, night has come. Today is gone, what's done is done.",
          author: "Unknown",
        ),
        QuoteModel(
          id: 1904,
          content: "Stars cannot shine without darkness.",
          author: "D.H. Sidebottom",
        ),
        QuoteModel(
          id: 1905,
          content: "Sleep is the best meditation.",
          author: "Dalai Lama",
        ),
      ],
      'mindset': [
        QuoteModel(
          id: 2001,
          content:
              "Whether you think you can or you think you can't, you're right.",
          author: "Henry Ford",
        ),
        QuoteModel(
          id: 2002,
          content:
              "Once your mindset changes, everything on the outside will change along with it.",
          author: "Steve Maraboli",
        ),
        QuoteModel(
          id: 2003,
          content:
              "Mind is a flexible mirror, adjust it to see a better world.",
          author: "Amit Ray",
        ),
        QuoteModel(
          id: 2004,
          content: "Change your thoughts and you change your world.",
          author: "Norman Vincent Peale",
        ),
        QuoteModel(
          id: 2005,
          content: "Believe you can and you're halfway there.",
          author: "Theodore Roosevelt",
        ),
      ],
    };

    return categoryData[category] ?? categoryData['faith']!;
  }
}