import 'package:flutter/material.dart';
import 'package:flutter_app/ui/breakpoint.dart';

class BreakpointProvider extends InheritedWidget {
  const BreakpointProvider({
    required super.child,
    required this.breakpoint,
    super.key,
  });

  final Breakpoint breakpoint;

  static Breakpoint of(BuildContext context) {
    final BreakpointProvider? result =
        context.dependOnInheritedWidgetOfExactType<BreakpointProvider>();
    assert(result != null, 'No BreakpointProvider found in context');
    return result!.breakpoint;
  }

  @override
  bool updateShouldNotify(BreakpointProvider old) {
    return old.breakpoint != breakpoint;
  }
}
