import 'package:flutter/material.dart';

enum BreakpointWidth {
  small(0, 600),
  medium(600, 840),
  large(840, double.infinity);

  const BreakpointWidth(this.begin, this.end);

  final double begin;
  final double end;
}

/// Convenience class that provides screen-width breakpoints and
/// based on Material 3 design spec. Also provides platform.
///
/// This is a simplified version of the same class in the
/// Flutter Adaptive Scaffold package, made by the Flutter team.
/// https://pub.dev/packages/flutter_adaptive_scaffold
class Breakpoint {
  Breakpoint({
    required this.platform,
    required this.width,
    required this.margin,
    required this.padding,
    required this.spacing,
  });

  factory Breakpoint.currentDevice(
    BuildContext context,
  ) => switch (MediaQuery.of(context).size.width) {
    >= 0 && < 600 => Breakpoint.small(platform: Theme.of(context).platform),
    >= 600 && < 840 => Breakpoint.medium(platform: Theme.of(context).platform),
    _ => Breakpoint.large(platform: Theme.of(context).platform),
  };

  const Breakpoint.small({required this.platform})
    : width = BreakpointWidth.small,
      margin = 16,
      spacing = 8,
      padding = 8;

  const Breakpoint.medium({required this.platform})
    : width = BreakpointWidth.medium,
      margin = 24,
      spacing = 16,
      padding = 8;

  const Breakpoint.large({required this.platform})
    : width = BreakpointWidth.large,
      margin = 24,
      spacing = 24,
      padding = 12;
  final TargetPlatform platform;

  final BreakpointWidth width;

  /// Margin for screens and other large views that run against the edges of
  /// of the viewport
  final double margin;

  /// Padding within an element
  final double padding;

  /// Padding between elements, such as two items in a column
  final double spacing;

  static const Set<TargetPlatform> cupertino = {
    TargetPlatform.iOS,
    TargetPlatform.macOS,
  };

  /// Returns true if the current platform is iOS or MacOS.
  static bool isCupertino(BuildContext context) {
    return cupertino.contains(Theme.of(context).platform);
  }
}
