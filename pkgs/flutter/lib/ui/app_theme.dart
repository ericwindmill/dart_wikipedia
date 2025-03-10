/*
 * // Copyright 2025 The Dart and Flutter teams. All rights reserved.
 * // Use of this source code is governed by a BSD-style license that can be
 * // found in the LICENSE file.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData materialLightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: materialLightTextTheme,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: Colors.white,
      onPrimaryContainer: AppColors.labelOnLight,
      shadow: Colors.black12,
    ),
    scaffoldBackgroundColor: AppColors.materialScaffoldBackgroundColor,
  );

  static ThemeData cupertinoLightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: cupertinoLightTextTheme,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: Colors.white,
      onPrimaryContainer: AppColors.labelOnLight,
      shadow: Colors.black12,
    ),
    scaffoldBackgroundColor: AppColors.cupertinoScaffoldBackgroundColor,
  );

  static TextTheme materialLightTextTheme = const TextTheme(
    headlineLarge: TextStyle(fontSize: 28, color: Colors.black),
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.black,
      fontFamily: 'Linux Libertine',
      fontFamilyFallback: <String>[
        'Georgia',
        'Times',
        'Source Serif Pro',
        'serif',
      ],
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(fontSize: 15, color: Colors.black, height: 1.3),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: AppColors.labelOnLight,
    ),
  );

  static TextTheme cupertinoLightTextTheme = TextTheme(
    headlineLarge: largeTitle,
    titleLarge: headline,
    titleMedium: subhead,
    bodyMedium: text,
    labelSmall: caption,
  );

  static const _cupertinoTextTheme = CupertinoTextThemeData();
  static TextStyle largeTitle = _cupertinoTextTheme.navLargeTitleTextStyle
      .copyWith(fontSize: 28);

  static TextStyle headline = _cupertinoTextTheme.textStyle.copyWith(
    fontSize: 18,
    color: Colors.black,

    fontFamily: 'Linux Libertine',
    fontFamilyFallback: <String>[
      'Georgia',
      'Times',
      'Source Serif Pro',
      'serif',
    ],
  );

  static TextStyle subhead = _cupertinoTextTheme.textStyle.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static TextStyle caption = _cupertinoTextTheme.textStyle.copyWith(
    color: CupertinoColors.secondaryLabel,
    fontSize: 12,
  );

  static TextStyle text = _cupertinoTextTheme.textStyle.copyWith(
    height: 1.3,
    fontSize: 15,
  );
}

abstract final class AppColors {
  static const Color primary = AppColors.flutterBlue;
  static const Color labelOnLight = Color(0xFF4A4A4A);
  static const Color materialScaffoldBackgroundColor = Color(0xFFFFFFFF);
  static const Color cupertinoScaffoldBackgroundColor = Color(0xFFF1F1F1);

  /// Colors from Flutter's brand guidelines
  static const Color warmRed = Color.fromRGBO(242, 93, 80, 1);
  static const Color lightYellow = Color.fromRGBO(255, 242, 117, 1);
  static const Color flutterBlue = Color.fromRGBO(4, 104, 215, 1);
}
