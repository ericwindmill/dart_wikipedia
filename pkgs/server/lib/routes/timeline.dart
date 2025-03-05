import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:wikipedia/wikipedia.dart';

abstract class TimelineApi {
  Router get router;
}

class TimelineApiDev extends TimelineApi {
  @override
  Router get router {
    return Router()..get('/<month>/<day>', (Request _) async {
      final file = File('./lib/test_data/on_this_day.json');
      final json = file.readAsStringSync();
      return Response.ok(json);
    });
  }
}

class TimelineApiRemote {
  Router get router {
    return Router()..get('/<month>/<day>', (
      Request request,
      String month,
      String day,
    ) async {
      try {
        if (!verifyMonthAndDate(month: int.parse(month), day: int.parse(day))) {
          throw const FormatException(
            'Month and date must be valid combination.',
          );
        }
      } on FormatException catch (error) {
        return Response.badRequest(body: {'message': error.message});
      }

      final http.Client client = http.Client();
      month = padNums(month);
      day = padNums(day);

      try {
        final Uri url = Uri.https(
          'en.wikipedia.org',
          '/api/rest_v1/feed/onthisday/all/$month/$day',
        );
        final http.Response response = await client.get(url);
        if (response.statusCode == 200) {
          return Response.ok(
            response.body,
            headers: {'Content-Type': 'application/json'},
          );
        } else {
          return Response.internalServerError();
        }
      } finally {
        client.close();
      }
    });
  }
}
