import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'features/on_this_day_timeline/page_view.dart';
import 'features/on_this_day_timeline/view_model.dart';
import 'features/saved_articles/page_view.dart';
import 'features/saved_articles/view_model.dart';
import 'repository_provider.dart';
import 'ui/app_theme.dart';
import 'ui/breakpoint.dart';
import 'ui/build_context_util.dart';

// This is not going to be included in the tutorial.
class CustomScrollBehavior extends CupertinoScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

void main() async {
  runApp(RepositoryProvider(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MaterialApp(
          theme:
              context.isCupertino
                  ? AppTheme.cupertinoLightTheme
                  : AppTheme.materialLightTheme,
          debugShowCheckedModeBanner: false,
          scrollBehavior: CustomScrollBehavior(),
          home: const HomeView(),
        );
      },
    );
  }
}

enum Destinations {
  timeline('Timeline', Icons.calendar_today_outlined, CupertinoIcons.calendar),
  savedArticles('Saved', Icons.bookmark_border, CupertinoIcons.bookmark);

  const Destinations(this.label, this.materialIcon, this.cupertinoIcon);

  final String label;
  final IconData materialIcon;
  final IconData cupertinoIcon;

  static Map<String, IconData> get materialDestinations {
    return <String, IconData>{
      for (final d in Destinations.values) d.label: d.materialIcon,
    };
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onSelectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = context.breakpoint;
    return Scaffold(
      appBar:
          context.breakpoint.isSmall
              ? AppBar(
                centerTitle: false,
                surfaceTintColor: Colors.white,
                title: Text(
                  'Wikipedia Dart',
                  style: TextTheme.of(context).titleLarge,
                ),
              )
              : null,

      body: Row(
        children: [
          if (context.breakpoint.isMedium || context.breakpoint.isLarge)
            Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white10)),
              ),
              child: NavigationRail(
                selectedIndex: _selectedIndex,
                extended: breakpoint.width == BreakpointWidth.large,
                onDestinationSelected: _onSelectTab,
                destinations: [
                  for (final d in Destinations.values)
                    NavigationRailDestination(
                      icon: Icon(d.cupertinoIcon),
                      label: Text(d.label),
                    ),
                ],
                // Nav rail Styles
                backgroundColor: Colors.white,
                indicatorColor: AppColors.primary,
                selectedLabelTextStyle: TextTheme.of(
                  context,
                ).labelSmall?.copyWith(color: AppColors.primary),
                selectedIconTheme: Theme.of(
                  context,
                ).iconTheme.copyWith(color: Colors.white),
                unselectedLabelTextStyle: TextTheme.of(context).labelSmall,
                unselectedIconTheme: Theme.of(
                  context,
                ).iconTheme.copyWith(color: AppColors.labelOnLight),
                leading: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.breakpoint.spacing,
                  ),
                  child: Text(
                    context.breakpoint.isLarge ? 'Wikipedia Dart' : 'W',
                    style: TextTheme.of(context).titleLarge,
                  ),
                ),
              ),
            ),
          Expanded(
            child:
                [
                  TimelinePageView(
                    viewModel: TimelineViewModel(
                      repository:
                          RepositoryProvider.of(context).timelineRepository,
                    ),
                  ),
                  SavedArticlesView(
                    viewModel: SavedArticlesViewModel(
                      repository:
                          RepositoryProvider.of(
                            context,
                          ).savedArticlesRepository,
                    ),
                  ),
                ][_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: switch ((breakpoint.width, context.isCupertino)) {
        (BreakpointWidth.small, true) => CupertinoTabBar(
          currentIndex: _selectedIndex,
          onTap: _onSelectTab,
          items:
              Destinations.values
                  .map<BottomNavigationBarItem>(
                    (d) => BottomNavigationBarItem(
                      icon: Icon(d.cupertinoIcon),
                      label: d.label,
                    ),
                  )
                  .toList(),
        ),
        (BreakpointWidth.small, false) => NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onSelectTab,
          destinations:
              Destinations.values
                  .map<Widget>(
                    (d) => NavigationDestination(
                      icon: Icon(d.materialIcon),
                      label: d.label,
                    ),
                  )
                  .toList(),
        ),
        _ => null,
      },
    );
  }
}
