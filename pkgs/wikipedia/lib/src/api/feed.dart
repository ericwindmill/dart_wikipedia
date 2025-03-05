/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/feed.dart';
import '../util.dart';

Future<WikipediaFeed> getWikipediaFeed() async {
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
    final http.Response response = await client.get(url);
    if (response.statusCode == 200) {
      final Map<String, Object?> jsonData =
          jsonDecode(response.body) as Map<String, Object?>;
      return WikipediaFeed.fromJson(jsonData);
    } else {
      throw HttpException(
        '[WikipediaDart.getWikipediaFeed] '
        'statusCode=${response.statusCode}, body=${response.body}',
      );
    }
  } on Exception catch (error) {
    throw Exception('Unexpected error - $error');
  } finally {
    client.close();
  }
}
