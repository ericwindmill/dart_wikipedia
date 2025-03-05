/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'package:wikipedia/wikipedia.dart';

import 'dart_summary.dart';

final wikipediaFeed = WikipediaFeed(
  todaysFeaturedArticle: dartSummary,
  onThisDayTimeline: [],
  mostRead: [],
  imageOfTheDay: WikipediaImage(
    title: 'Carrot in a field',
    originalImage: ImageFile(source: '', width: 100, height: 100),
  ),
);
