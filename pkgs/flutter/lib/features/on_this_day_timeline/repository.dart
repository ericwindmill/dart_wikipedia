/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wikipedia/wikipedia.dart';

abstract class SimpleCache {
  DateTime _prevCacheTime = DateTime.now();
  final Duration _cacheDuration = Duration(hours: 4);

  bool get shouldClearCache {
    if (_prevCacheTime.add(_cacheDuration).isBefore(DateTime.now())) {
      return true;
    }
    return false;
  }
}

class TimelineRepository extends SimpleCache {
  OnThisDayTimeline? _cachedTimeline;
  Future<OnThisDayTimeline> getTimelineForDate(int month, int day) async {
    if (_cachedTimeline != null && !shouldClearCache) return _cachedTimeline!;
    final http.Client client = http.Client();

    try {
      final Uri url = Uri.http('localhost:8080', '/timeline/$month/$day');
      final http.Response response = await client.get(url);
      if (response.statusCode == 200) {
        final Map<String, Object?> jsonData = jsonDecode(response.body);
        _cachedTimeline = OnThisDayTimeline.fromJson(jsonData);
        _prevCacheTime = DateTime.now();
        return _cachedTimeline!;
      } else {
        throw Exception(
          '[TimelineRepository.getTimelineForDate] '
          'statusCode=${response.statusCode}, '
          'body=${response.body}',
        );
      }
    } finally {
      client.close();
    }
  }
}
