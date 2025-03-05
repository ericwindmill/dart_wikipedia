import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:wikipedia/wikipedia.dart';

abstract class WikipediaFeedApi {
  Router get router;
}

class WikipediaFeedApiDev extends WikipediaFeedApi {
  @override
  Router get router {
    return Router()..get('/', (Request _) async {
      final file = File('./lib/test_data/wikipedia_feed.json');
      final json = file.readAsStringSync();
      return Response.ok(json, headers: {'Content-Type': 'application/json'});
    });
  }
}

class WikipediaFeedApiRemote extends WikipediaFeedApi {
  @override
  Router get router {
    final router =
        Router()..get('/', (Request _) async {
          final DateTime date = DateTime.now();
          final int year = date.year;
          final String month = toStringWithPad(date.month);
          final String day = toStringWithPad(date.day);
          final http.Client client = http.Client();
          try {
            final Uri url = Uri.https(
              'en.wikipedia.org',
              '/api/rest_v1/feed/featured/$year/$month/$day',
            );
            final http.Response wikiResponse = await client.get(url);
            if (wikiResponse.statusCode == 200) {
              return Response.ok(
                wikiResponse.body,
                headers: {'Content-Type': 'application/json'},
              );
            } else if (wikiResponse.statusCode == 404) {
              return Response.notFound(
                '[WikipediaDart.getWikipediaFeed] '
                'statusCode=${wikiResponse.statusCode}, '
                'body=${wikiResponse.body}',
              );
            }
          } on HttpException catch (error) {
            // TODO(ewindmill): log
            throw HttpException('Unexpected error - $error');
          } finally {
            client.close();
          }
        });

    return router;
  }
}
