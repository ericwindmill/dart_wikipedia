/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/features/saved_articles/saved_articles_repository.dart';
import 'package:wikipedia/src/model/summary.dart';

class FakeSavedArticlesRepository extends ChangeNotifier
    implements SavedArticlesRepository {
  @override
  void removeArticle(Summary summary) {}

  @override
  void saveArticle(Summary summary) {}

  @override
  // TODO: implement savedArticles
  ValueNotifier<Map<String, Summary>> get savedArticles => ValueNotifier({});
}
