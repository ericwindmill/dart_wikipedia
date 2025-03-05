import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ArticleApi {
  Router get router {
    return Router()..get('/<title>', (Request request, String title) async {
      final http.Client client = http.Client();
      try {
        final Uri url = Uri.https(
          'en.wikipedia.org',
          '/w/api.php',
          <String, Object?>{
            // order matters - explaintext must come after prop
            'action': 'query',
            'format': 'json',
            'titles': title.trim(),
            'prop': 'extracts',
            'explaintext': '',
          },
        );
        final http.Response response = await client.get(url);
        if (response.statusCode == 200) {
          return Response.ok(
            response.body,
            headers: {'Content-Type': 'application/json'},
          );
        } else {
          return Response.notFound(response.body);
        }
      } on HttpException catch (error) {
        // TODO(ewindmill): log, then return an internalServerError
        throw HttpException('Unexpected error - $error');
      } finally {
        client.close();
      }
    });
  }
}
