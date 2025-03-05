import 'dart:convert';

import 'package:flutter_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:wikipedia/wikipedia.dart';

class FeedRepository {
  WikipediaFeed? _cachedFeed;
  Summary? _cachedRandomArticle;

  Future<WikipediaFeed> getWikipediaFeed() async {
    if (_cachedFeed != null) return _cachedFeed!;
    final http.Client client = http.Client();

    try {
      final Uri url = Uri.http(serverUri, '/feed');
      final http.Response response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, Object?> jsonData = jsonDecode(response.body);
        _cachedFeed = WikipediaFeed.fromJson(jsonData);
        return _cachedFeed!;
      } else {
        throw Exception(
          '[WikipediaDart.getWikipediaFeed] '
          'statusCode=${response.statusCode}, '
          'body=${response.body}',
        );
      }
    } finally {
      client.close();
    }
  }

  Future<Summary> getRandomArticle() async {
    if (_cachedRandomArticle != null) return _cachedRandomArticle!;

    final http.Client client = http.Client();
    final Uri url = Uri.http(serverUri, '/page/random');
    final http.Response response = await client.get(url);
    if (response.statusCode == 200) {
      final Map<String, Object?> jsonData =
          jsonDecode(response.body) as Map<String, Object?>;
      _cachedRandomArticle = Summary.fromJson(jsonData);
      return _cachedRandomArticle!;
    } else {
      throw Exception(
        '[WikipediaDart.getWikipediaFeed] '
        'statusCode=${response.statusCode}, '
        'body=${response.body}',
      );
    }
  }
}
