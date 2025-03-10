/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'breakpoint.dart';

extension Adaptive on BuildContext {
  Breakpoint get breakpoint => Breakpoint.current(this);

  bool get isCupertino {
    return [
      TargetPlatform.iOS,
      TargetPlatform.macOS,
    ].contains(Theme.of(this).platform);
  }

  PageRoute<Object> adaptivePageRoute({
    required WidgetBuilder builder,
    String? title,
  }) {
    if (isCupertino) {
      return CupertinoPageRoute(builder: builder, title: title);
    } else {
      return MaterialPageRoute(builder: builder);
    }
  }
}
