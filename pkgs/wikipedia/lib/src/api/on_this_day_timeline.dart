/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../exceptions.dart';
import '../model/event_type.dart';
import '../model/on_this_day_timeline.dart';
import '../util.dart';

/// [month] and [day] should be 2 digits, padded with a 0 if necessary.
Future<OnThisDayTimeline> getTimelineForDate({
  required int month,
  required int day,
  // Be default, fetch all types.
  EventType? type,
}) async {
  if (!verifyMonthAndDate(month: month, day: day)) {
    throw Exception('Month and date must be valid combination.');
  }

  final String strMonth = toStringWithPad(month);
  final String strDay = toStringWithPad(day);
  final String strType = type == null ? 'all' : type.apiStr;

  final http.Client client = http.Client();
  try {
    final Uri url = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/feed/onthisday/$strType/$strMonth/$strDay',
    );

    final http.Response response = await client.get(url);
    if (response.statusCode == 200) {
      final Map<String, Object?> jsonData =
          jsonDecode(response.body) as Map<String, Object?>;
      return OnThisDayTimeline.fromJson(jsonData);
    } else {
      throw HttpException(
        '[WikipediaDart.getTimelineForDate] '
        'statusCode=${response.statusCode}, body=${response.body}',
      );
    }
  } on Exception catch (error) {
    throw Exception('Unexpected error - $error');
  } finally {
    client.close();
  }
}
