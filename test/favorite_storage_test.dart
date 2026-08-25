import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_voice/screens/favorite_bloc.dart';
import 'package:soul_voice/screens/favorite_event.dart';
import 'package:soul_voice/services/favorite_storage_service.dart';
import 'package:soul_voice/services/quote_api_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FavoriteStorageService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Clean quote text removes quotes, special characters, and trims', () {
      expect(
        FavoriteStorageService.cleanQuoteText('“Hello, world!”'),
        'Hello, world!',
      );
      expect(
        FavoriteStorageService.cleanQuoteText('"Faith is power."'),
        'Faith is power.',
      );
      expect(
        FavoriteStorageService.cleanQuoteText('  ‘Be kind.’  '),
        'Be kind.',
      );
    });

    test('isSameQuote matches quotes correctly regardless of quotation marks or casing', () {
      expect(
        FavoriteStorageService.isSameQuote(
          '“Faith makes things possible.”',
          'Faith makes things possible.',
        ),
        isTrue,
      );

      expect(
        FavoriteStorageService.isSameQuote(
          {'quote': '“Kindness is a language”', 'author': 'Mark Twain'},
          'Kindness is a language',
        ),
        isTrue,
      );

      expect(
        FavoriteStorageService.isSameQuote(
          {'quote': 'Quote A'},
          {'quote': 'Quote B'},
        ),
        isFalse,
      );
    });

    test('Saves and loads favorites to/from SharedPreferences', () async {
      final service = FavoriteStorageService();

      final quotesToSave = [
        {'quote': '“Peace begins with a smile.”', 'author': 'Mother Teresa'},
        {'quote': 'Wisdom begins in wonder.', 'author': 'Socrates'},
      ];

      final saved = await service.saveFavorites(quotesToSave);
      expect(saved, isTrue);

      final loaded = await service.loadFavorites();
      expect(loaded.length, 2);
      expect(loaded[0]['quote'], 'Peace begins with a smile.');
      expect(loaded[0]['author'], 'Mother Teresa');
      expect(loaded[1]['quote'], 'Wisdom begins in wonder.');
      expect(loaded[1]['author'], 'Socrates');
    });

    test('Clear favorites empties storage', () async {
      final service = FavoriteStorageService();
      await service.saveFavorites([
        {'quote': 'Test Quote', 'author': 'Author'}
      ]);

      var loaded = await service.loadFavorites();
      expect(loaded.length, 1);

      await service.clearFavorites();
      loaded = await service.loadFavorites();
      expect(loaded.isEmpty, isTrue);
    });
  });

  group('FavoriteBloc Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('FavoriteBloc loads initial favorites and toggles favorites properly', () async {
      final bloc = FavoriteBloc();

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.favoriteQuotes.isEmpty, isTrue);

      // Add a quote
      bloc.add(
        const ToggleFavoriteEvent({
          'quote': 'Stay hungry, stay foolish.',
          'author': 'Steve Jobs',
        }),
      );

      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.favoriteQuotes.length, 1);
      expect(bloc.state.isFavoriteText('Stay hungry, stay foolish.'), isTrue);
      expect(bloc.state.isFavoriteText('“Stay hungry, stay foolish.”'), isTrue);

      // Remove quote by toggling again
      bloc.add(
        const ToggleFavoriteEvent({
          'quote': '“Stay hungry, stay foolish.”',
          'author': 'Steve Jobs',
        }),
      );

      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.favoriteQuotes.isEmpty, isTrue);
      expect(bloc.state.isFavoriteText('Stay hungry, stay foolish.'), isFalse);

      await bloc.close();
    });

    test('Persistence across bloc instances (simulating app restart)', () async {
      // Instance 1 adds a favorite
      final bloc1 = FavoriteBloc();
      await Future.delayed(const Duration(milliseconds: 50));

      bloc1.add(
        const ToggleFavoriteEvent({
          'quote': 'Every moment is a fresh beginning.',
          'author': 'T.S. Eliot',
        }),
      );
      await Future.delayed(const Duration(milliseconds: 100));
      await bloc1.close();

      // Instance 2 (like restart) loads from storage
      final bloc2 = FavoriteBloc();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(bloc2.state.favoriteQuotes.length, 1);
      expect(
        bloc2.state.favoriteQuotes.first['quote'],
        'Every moment is a fresh beginning.',
      );
      expect(
        bloc2.state.isFavoriteText('Every moment is a fresh beginning.'),
        isTrue,
      );

      await bloc2.close();
    });
  });

  group('Complete Offline QuoteApiService Tests', () {
    final apiService = QuoteApiService();

    test('Featured quotes getQuotes() works offline with pagination', () async {
      final page1 = await apiService.getQuotes(page: 1, limit: 15);
      expect(page1.length, 15);
      expect(page1.first.content.isNotEmpty, isTrue);

      final page2 = await apiService.getQuotes(page: 2, limit: 15);
      expect(page2.length, 15);
      expect(page2.first.content, isNot(page1.first.content));
    });

    test('Category quotes getAllQuotesByCategory() returns 30 offline quotes for all categories', () async {
      final faithQuotes = await apiService.getAllQuotesByCategory('faith');
      expect(faithQuotes.length, 30);

      final peaceQuotes = await apiService.getAllQuotesByCategory('peace');
      expect(peaceQuotes.length, 30);

      final wisdomQuotes = await apiService.getAllQuotesByCategory('wisdom');
      expect(wisdomQuotes.length, 30);

      final loveQuotes = await apiService.getAllQuotesByCategory('love');
      expect(loveQuotes.length, 30);
    });

    test('Offline Search searchQuotes() finds matching quotes by keywords and text', () async {
      final results1 = await apiService.searchQuotes('Allah');
      expect(results1, isNotEmpty);

      final results2 = await apiService.searchQuotes('peace');
      expect(results2, isNotEmpty);

      final results3 = await apiService.searchQuotes('patience');
      expect(results3, isNotEmpty);
    });

    test('Random quote fetchRandomQuote() works offline', () async {
      final quote = await apiService.fetchRandomQuote();
      expect(quote.content.isNotEmpty, isTrue);
      expect(quote.author.isNotEmpty, isTrue);
    });

    test('All quotes fetchAllQuotes() returns 600 offline quotes', () async {
      final all = await apiService.fetchAllQuotes();
      expect(all.length, greaterThanOrEqualTo(500));
    });
  });
}
