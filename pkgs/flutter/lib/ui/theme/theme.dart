import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class CupertinoAppTheme {
  static CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    barBackgroundColor: Colors.white,
    textTheme: lightTextTheme,
  );

  static CupertinoTextThemeData lightTextTheme = CupertinoTextThemeData(
    textStyle: body,
    navLargeTitleTextStyle: largeTitle,
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

  static TextStyle body = _cupertinoTextTheme.textStyle.copyWith(
    height: 1.3,
    fontSize: 15,
  );
}

abstract final class MaterialAppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: lightTextTheme,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: Colors.white,
      onPrimaryContainer: AppColors.labelOnLight,
      shadow: Colors.black12,
    ),
    scaffoldBackgroundColor: AppColors.materialScaffoldBackgroundColor,
  );

  static TextTheme lightTextTheme = const TextTheme(
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
}

abstract final class AppDimensions {
  static const double radius = 8;
  static const double iconSize = 16;
}

abstract final class AppColors {
  static const Color primary = AppColors.flutterBlue5;
  static const Color labelOnLight = Color(0xFF4A4A4A);
  static const Color materialScaffoldBackgroundColor = Color(0xFFFFFFFF);
  static const Color cupertinoScaffoldBackgroundColor = Color(0xFFF1F1F1);

  /// All colors from Flutter's brand guidelines
  static const Color warmRed = Color.fromRGBO(242, 93, 80, 1);
  static const Color lightYellow = Color.fromRGBO(255, 242, 117, 1);

  static const Color flutterBlue5 = Color.fromRGBO(4, 104, 215, 1);
  static const Color flutterBlue4 = Color.fromRGBO(2, 125, 253, 1);
  static const Color flutterBlue3 = Color.fromRGBO(19, 185, 253, 1);
  static const Color flutterBlue2 = Color.fromRGBO(129, 221, 249, 1);
  static const Color flutterBlue1 = Color.fromRGBO(184, 224, 254, 1);
}
