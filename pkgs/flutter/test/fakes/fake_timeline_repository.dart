/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'package:flutter_app/features/on_this_day/timeline_repository.dart';
import 'package:wikipedia/src/model/on_this_day_timeline.dart';

class FakeTimelineRepository implements TimelineRepository {
  @override
  Future<OnThisDayTimeline> getTimelineForDate(int month, int day) async {
    return OnThisDayTimeline();
  }
}
