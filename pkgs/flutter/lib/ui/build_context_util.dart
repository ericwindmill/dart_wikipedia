import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/breakpoint.dart';
import 'package:flutter_app/ui/theme/theme.dart';

extension Adaptive on BuildContext {
  bool get isCupertino => Breakpoint.isCupertino(this);

  TextStyle get headlineLarge {
    if (isCupertino) return CupertinoAppTheme.largeTitle;
    return MaterialAppTheme.lightTextTheme.headlineLarge!;
  }

  TextStyle get titleLarge {
    if (isCupertino) return CupertinoAppTheme.headline;
    return MaterialAppTheme.lightTextTheme.titleLarge!;
  }

  TextStyle get titleMedium {
    if (isCupertino) return CupertinoAppTheme.subhead;
    return MaterialAppTheme.lightTextTheme.titleMedium!;
  }

  TextStyle get bodyMedium {
    if (isCupertino) return CupertinoAppTheme.body;
    return MaterialAppTheme.lightTextTheme.bodyMedium!;
  }

  TextStyle get labelSmall {
    if (isCupertino) return CupertinoAppTheme.caption;
    return MaterialAppTheme.lightTextTheme.labelSmall!;
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
