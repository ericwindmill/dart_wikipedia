import 'dart:convert';

import 'package:flutter_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:wikipedia/wikipedia.dart';

class TimelineRepository {
  OnThisDayTimeline? _cachedTimeline;

  Future<OnThisDayTimeline> getTimelineForDate(int month, int day) async {
    if (_cachedTimeline != null) return _cachedTimeline!;
    final http.Client client = http.Client();

    try {
      final Uri url = Uri.http(serverUri, '/timeline/$month/$day');
      final http.Response response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, Object?> jsonData = jsonDecode(response.body);
        _cachedTimeline = OnThisDayTimeline.fromJson(jsonData);
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
