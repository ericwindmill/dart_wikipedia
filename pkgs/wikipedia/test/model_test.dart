import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:wikipedia/wikipedia.dart';

const String dartLangSummaryJson = './test/test_data/dart_lang_summary.json';
const String terryItoInnerJson = './test/test_data/terry_ito_inner.json';
const String onThisDayPath =
    './test/test_data/on_this_day_response_example.json';
const String brockPurdyInnerJson = './test/test_data/brock_purdy_inner.json';
const String catExtractJson = './test/test_data/cat_extract.json';
const String openSearchResponse = './test/test_data/open_search_response.json';
const String wikipediaFeedResponse =
    './test/test_data/wikipedia_feed_response.json';
const String churchImageJson = './test/test_data/church_image.json';

void main() {
  group('deserialize example JSON responses from wikipedia API', () {
    test('deserialize Terry Ito page on-this-day example data from '
        'json file into an OnThisDayInner object', () async {
      final String pageSummaryInput =
          await File(terryItoInnerJson).readAsString();
      final Map<String, Object?> pageSummaryMap =
          jsonDecode(pageSummaryInput) as Map<String, Object?>;
      final OnThisDayEvent summary = OnThisDayEvent.fromJson(
        pageSummaryMap,
        EventType.birthday,
      );
      expect(summary.year, 1949);
    });

    test('deserialize Dart Programming Language page summary example data from '
        'json file into a Summary object', () async {
      final String pageSummaryInput =
          await File(dartLangSummaryJson).readAsString();
      final Map<String, Object?> pageSummaryMap =
          jsonDecode(pageSummaryInput) as Map<String, Object?>;
      final Summary summary = Summary.fromJson(pageSummaryMap);
      expect(summary.titles.canonical, 'Dart_(programming_language)');
    });

    test('deserialize Brock Purdy on-this-day example data from json file into '
        'an OnThisDayInner object', () async {
      final String onThisDayInnerInput =
          await File(brockPurdyInnerJson).readAsString();
      final Map<String, Object?> onThisDayInnerMap =
          jsonDecode(onThisDayInnerInput) as Map<String, Object?>;
      final OnThisDayEvent onThisDayInner = OnThisDayEvent.fromJson(
        onThisDayInnerMap,
        EventType.birthday,
      );
      expect(onThisDayInner.year, 1999);
    });

    test('deserialize on this day test data from json file into an '
        'OnThisDayResponse object', () async {
      final String onThisDayInput = await File(onThisDayPath).readAsString();
      final Map<String, Object?> onThisDayMap =
          jsonDecode(onThisDayInput) as Map<String, Object?>;
      final OnThisDayTimeline onThisDayResponse = OnThisDayTimeline.fromJson(
        onThisDayMap,
      );
      expect(onThisDayResponse.selected.length, 15);
    });
  });

  group('deserialize example JSON responses from wikipedia API', () {
    test('deserialize Cat article example data from json file into '
        'an Article object', () async {
      final String articleJson = await File(catExtractJson).readAsString();
      final dynamic articleAsMap = jsonDecode(articleJson);
      final List<Article> article = Article.listFromJson(
        articleAsMap as Map<String, Object?>,
      );
      expect(article.first.title.toLowerCase(), 'cat');
    });

    test('deserialize Open Search results example data from json file '
        'into an SearchResults object', () async {
      final String resultsString =
          await File(openSearchResponse).readAsString();
      final List<Object?> resultsAsList =
          jsonDecode(resultsString) as List<Object?>;
      final SearchResults results = SearchResults.fromJson(resultsAsList);
      expect(results.results.length, greaterThan(1));
    });

    test('deserialize WikipediaFeed results from json file', () async {
      final String resultsString =
          await File(wikipediaFeedResponse).readAsString();
      final Map<String, Object?> resultsAsMap =
          jsonDecode(resultsString) as Map<String, Object?>;
      final WikipediaFeed feed = WikipediaFeed.fromJson(resultsAsMap);
      expect(feed, isNotNull);
    });

    test('deserialize image results from json file', () async {
      final String resultsString = await File(churchImageJson).readAsString();
      final Map<String, Object?> resultsAsMap =
          jsonDecode(resultsString) as Map<String, Object?>;
      final WikipediaImage image = WikipediaImage.fromJson(resultsAsMap);
      expect(image, isNotNull);
    });
  });
}
