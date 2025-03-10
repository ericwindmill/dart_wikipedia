/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:wikipedia/wikipedia.dart';

import 'article_view.dart';

class ArticlePageView extends StatelessWidget {
  const ArticlePageView({required this.summary, super.key});

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: ArticleView(summary: summary));
  }
}
