import 'package:test/test.dart';
import 'package:wikipedia/wikipedia.dart';

void main() {
  group('Fetch from Wikipedia API', () {
    test('Fetches cat summary from wikipedia', () async {
      final Summary summary = await getArticleSummaryByTitle('cat');
      expect(summary.titles.normalized.toLowerCase(), 'cat');
    });

    test('Fetches random article summary from wikipedia', () async {
      final Summary summary = await getRandomArticleSummary();
      expect(summary, isNotNull);
    });

    test("Fetches 'on this day' timeline from Wikipedia", () async {
      final OnThisDayTimeline timeline = await getTimelineForDate(
        month: 8,
        day: 2,
      );
      expect(timeline.selected, isNotEmpty);
    });

    test(
      "Fetches on 'selected' events from 'on this day' timeline from Wikipedia",
      () async {
        final OnThisDayTimeline timeline = await getTimelineForDate(
          month: 8,
          day: 2,
          type: EventType.selected,
        );
        expect(timeline.selected, isNotEmpty);
      },
    );

    test('Fetches the feed', () async {
      final WikipediaFeed feed = await getWikipediaFeed();
      expect(feed.todaysFeaturedArticle, isNotNull);
    });
  });
  //
  group('Fetch from wikimedia api', () {
    test('Fetches cat article extract from wikipedia', () async {
      final List<Article> articles = await getArticleByTitle('cat');
      expect(articles.length, greaterThan(0));
      expect(articles.first.title.toLowerCase(), 'cat');
    });

    test("Handles disambiguation page when article title doesn't match a "
        'wikipedia article name', () async {
      final List<Article> articles = await getArticleByTitle('dart');
      expect(articles.length, greaterThan(0));
      expect(articles.first.title.toLowerCase(), 'dart');
    });

    test('Handles searching', () async {
      final SearchResults searchResults = await search('dart');
      expect(searchResults.searchTerm, 'dart');
      expect(searchResults.results.length, greaterThan(0));
    });
  });
}
