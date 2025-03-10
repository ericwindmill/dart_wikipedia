import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wikipedia/wikipedia.dart';

import '../../ui/app_theme.dart';
import '../../ui/breakpoint.dart';
import '../../ui/build_context_util.dart';
import '../../ui/shared_widgets/article_page_view.dart';
import '../../ui/shared_widgets/article_view.dart';
import '../../ui/shared_widgets/rounded_image.dart';
import 'view_model.dart';

class SavedArticlesView extends StatelessWidget {
  const SavedArticlesView({required this.viewModel, super.key});

  final SavedArticlesViewModel viewModel;

  Future<void> _onTapArticle(Summary summary, BuildContext context) async {
    if (context.breakpoint.width != BreakpointWidth.large) {
      await Navigator.of(context).push(
        context.adaptivePageRoute(
          title: summary.titles.normalized,
          builder: (BuildContext context) {
            return ArticlePageView(summary: summary);
          },
        ),
      );
    } else {
      viewModel.activeArticle = summary;
    }
  }

  Widget _listTile(BuildContext context, Summary summary, Widget? trailing) {
    if (context.isCupertino) {
      return CupertinoListTile(
        backgroundColor: Colors.white,
        trailing:
            context.breakpoint.width != BreakpointWidth.small
                ? IconButton(
                  icon: const Icon(CupertinoIcons.clear_circled),
                  onPressed: () => viewModel.removeArticle(summary),
                )
                : null,
        title: Text(
          summary.titles.normalized,
          style: TextTheme.of(context).bodyMedium,
        ),
        subtitle: Text(
          summary.description ?? '',
          style: TextTheme.of(context).labelSmall,
        ),
        leading: trailing,
        onTap: () => _onTapArticle(summary, context),
      );
    } else {
      return ListTile(
        title: Text(summary.titles.normalized),
        subtitle: Text(summary.description ?? ''),
        trailing: trailing,
        onTap: () => _onTapArticle(summary, context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final breakpoint = context.breakpoint;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, snapshot) {
        if (viewModel.savedArticles.isEmpty) {
          return Center(
            child: Text(
              'No saved articles',
              style: TextTheme.of(context).labelSmall,
            ),
          );
        }

        final mainContent = ColoredBox(
          color: AppColors.cupertinoScaffoldBackgroundColor,
          child: ListView.separated(
            itemCount: viewModel.savedArticles.length,
            separatorBuilder: (context, index) {
              return const Divider(thickness: .1, height: .1);
            },
            itemBuilder: (context, index) {
              final summary =
                  viewModel.savedArticles.entries.elementAt(index).value;
              final Widget? image =
                  summary.hasImage
                      ? RoundedImage(
                        source: summary.preferredSource!,
                        height: 30,
                        width: 30,
                      )
                      : null;

              return Dismissible(
                key: Key(summary.titles.canonical),
                onDismissed: (details) {
                  viewModel.removeArticle(summary);
                },
                direction:
                    breakpoint.width == BreakpointWidth.small
                        ? DismissDirection.endToStart
                        : DismissDirection.none,
                background: const ColoredBox(
                  color: AppColors.warmRed,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(CupertinoIcons.delete, color: Colors.black26),
                    ),
                  ),
                ),
                child: ColoredBox(
                  color: Colors.white,
                  child: _listTile(context, summary, image),
                ),
              );
            },
          ),
        );

        final withTitle = Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 60,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(context.breakpoint.padding),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Saved Articles',
                  style: TextTheme.of(context).titleMedium,
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              bottom: 0,
              child: mainContent,
            ),
          ],
        );

        final right =
            viewModel.activeArticle != null
                ? ArticleView(summary: viewModel.activeArticle!)
                : const Center(child: Text('Select an article'));

        if (breakpoint.width == BreakpointWidth.large) {
          return Row(
            children: [
              Flexible(flex: 2, child: withTitle),
              Flexible(flex: 3, child: right),
            ],
          );
        }

        return withTitle;
      },
    );
  }
}
