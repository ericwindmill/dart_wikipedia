import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wikipedia/wikipedia.dart';

Future<Summary> getArticleSummary(String title) async {
  final http.Client client = http.Client();
  try {
    final Uri url = Uri.http('localhost:8080', '/summary/$title');
    final http.Response response = await client.get(url);
    if (response.statusCode == 200) {
      final Map<String, Object?> jsonData = jsonDecode(response.body);
      return Summary.fromJson(jsonData);
    } else {
      throw HttpException(
        'HttpException Wikipedia.getWikipediaFeed, ${response.body}',
        statusCode: response.statusCode,
      );
    }
  } finally {
    client.close();
  }
}
