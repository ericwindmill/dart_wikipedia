import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/breakpoint_provider.dart';
import 'package:flutter_app/ui/breakpoint.dart';
import 'package:flutter_app/ui/build_context_util.dart';
import 'package:flutter_app/ui/shared_widgets/cupertino_side_nav.dart';
import 'package:flutter_app/ui/shared_widgets/transitions/animations.dart';
import 'package:flutter_app/ui/shared_widgets/transitions/bottom_bar_transition.dart';
import 'package:flutter_app/ui/shared_widgets/transitions/nav_rail_transition.dart';
import 'package:flutter_app/ui/theme/theme.dart';

class AdaptiveNavigation extends StatefulWidget {
  const AdaptiveNavigation({
    required this.tabs,
    this.title,
    this.collapsedTitle,
    this.navigationItems,
    this.actions = const [],
    this.onSelectIndex,
    this.initialSelectedIndex = 0,
    this.scaffoldBackgroundColor,
    super.key,
  });

  final Widget? title;
  final Widget? collapsedTitle;
  final List<Widget> tabs;
  final Map<String, IconData>? navigationItems;
  final List<Widget> actions;
  final ValueChanged<int>? onSelectIndex;
  final Color? scaffoldBackgroundColor;
  final int initialSelectedIndex;

  @override
  State<AdaptiveNavigation> createState() => AdaptiveNavigationState();
}

class AdaptiveNavigationState extends State<AdaptiveNavigation>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _selectedIndex = widget.initialSelectedIndex;
    super.initState();
  }

  late int _selectedIndex;

  void selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
      if (widget.onSelectIndex != null) {
        widget.onSelectIndex!.call(index);
      }
      _selectedIndex = index;
    });
  }

  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    reverseDuration: const Duration(milliseconds: 1250),
    value: 0,
    vsync: this,
  );
  bool controllerInitialized = false;
  late final _barAnimation = BarAnimation(parent: _controller);
  late final _railAnimation = RailAnimation(parent: _controller);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = _controller.status;
    if (width > BreakpointWidth.small.end) {
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        _controller.forward();
      }
    } else {
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        _controller.reverse();
      }
    }
    if (!controllerInitialized) {
      controllerInitialized = true;
      _controller.value = width > BreakpointWidth.small.end ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static AdaptiveNavigationState of(BuildContext context) {
    final state = context.findAncestorStateOfType<AdaptiveNavigationState>();
    if (state != null) {
      return state;
    }
    throw FlutterError(
      'AdaptiveTabScaffoldState.of(context) called in a '
      "context that doesn't include a AdaptiveTabScaffoldState.",
    );
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = BreakpointProvider.of(context);

    final bottomBar = BottomBarTransition(
      animation: _barAnimation,
      backgroundColor: Colors.white,
      child:
          context.isCupertino
              ? CupertinoTabBar(
                currentIndex: _selectedIndex,
                onTap: selectIndex,
                items:
                    widget.navigationItems!.entries
                        .map<BottomNavigationBarItem>(
                          (entry) => BottomNavigationBarItem(
                            icon: Icon(entry.value),
                            label: entry.key,
                          ),
                        )
                        .toList(),
              )
              : NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: selectIndex,
                indicatorColor: AppColors.flutterBlue3,
                destinations:
                    widget.navigationItems!.entries
                        .map<Widget>(
                          (entry) => NavigationDestination(
                            icon: Icon(entry.value),
                            label: entry.key,
                          ),
                        )
                        .toList(),
              ),
    );

    final navRail = NavRailTransition(
      animation: _railAnimation,
      backgroundColor: Colors.white,
      child:
          context.isCupertino
              ? CupertinoSideNav(
                title: widget.title ?? Container(),
                collapsedTitle: widget.collapsedTitle,
                leading: Row(children: widget.actions),
                navigationItems: widget.navigationItems!,
                extended: breakpoint.width == BreakpointWidth.large,
                onDestinationSelected: selectIndex,
                selectedIndex: _selectedIndex,
                selectedIndicatorColor: AppColors.flutterBlue1,
                backgroundColor: Colors.white,
              )
              : NavigationRail(
                destinations: [
                  for (final d in widget.navigationItems!.entries)
                    NavigationRailDestination(
                      icon: Icon(d.value),
                      label: Text(d.key),
                    ),
                ],
                backgroundColor: Colors.black12,
                selectedIndex: _selectedIndex,
                extended: breakpoint.width == BreakpointWidth.large,
                indicatorColor: AppColors.flutterBlue1,
                onDestinationSelected: selectIndex,
              ),
    );

    return Row(
      children: [
        navRail,
        Flexible(
          child: Column(
            children: [Flexible(child: widget.tabs[_selectedIndex]), bottomBar],
          ),
        ),
      ],
    );
  }
}
