/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'package:flutter_app/features/feed/feed_repository.dart';
import 'package:wikipedia/wikipedia.dart';

import '../test_data/dart_summary.dart';
import '../test_data/wikipedia_feed.dart';

class FakeFeedRepository implements FeedRepository {
  @override
  Future<Summary> getRandomArticle() async {
    return dartSummary;
  }

  @override
  Future<WikipediaFeed> getWikipediaFeed() async {
    return wikipediaFeed;
  }
}
