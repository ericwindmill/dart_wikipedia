/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'package:flutter/material.dart';

import 'features/on_this_day_timeline/repository.dart';
import 'features/saved_articles/repository.dart';

class RepositoryProvider extends InheritedWidget {
  RepositoryProvider({required super.child, super.key});

  final TimelineRepository timelineRepository = TimelineRepository();
  final SavedArticlesRepository savedArticlesRepository =
      SavedArticlesRepository();

  static RepositoryProvider of(BuildContext context) {
    final RepositoryProvider? result =
        context.dependOnInheritedWidgetOfExactType<RepositoryProvider>();
    assert(result != null, 'No RepositoryProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(RepositoryProvider old) {
    return false;
  }
}
