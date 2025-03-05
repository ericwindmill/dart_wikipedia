/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'package:wikipedia/wikipedia.dart';

final Summary dartSummary = Summary(
  titles: TitlesSet(
    canonical: 'Dart_(Programming_Language)',
    normalized: 'Dart (Programming Language)',
    display: '<b>Dart</b>',
  ),
  pageid: 123,
  extract:
      'Dart is a programming language designed by Lars Bak and Kasper Lund and developed by Google. It can be used to develop web and mobile apps as well as server and desktop applications.',
  lang: 'en',
  dir: 'ltr',
  extractHtml:
      '"<p><b>Dart</b> is a programming language designed by Lars Bak and Kasper Lund and developed by Google. It can be used to develop web and mobile apps as well as server and desktop applications.</p>"',
);
